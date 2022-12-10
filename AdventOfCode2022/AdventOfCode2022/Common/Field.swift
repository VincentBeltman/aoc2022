//
//  Field.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 09/12/2022.
//

import Foundation

typealias StringField = Field<String>
typealias IntField = Field<Int>

class Field<T: Comparable>: CustomStringConvertible
{
  class Coord: Equatable
  {
    var y: Int
    var x: Int

    init(y: Int, x: Int)
    {
      self.y = y
      self.x = x
    }

    func isIn(field: Field) -> Bool
    {
      return ((y >= 0) && (x >= 0) && (y < field.height) && (x < field.width))
    }

    static func == (lhs: Coord, rhs: Coord) -> Bool
    {
      return lhs.x == rhs.x && lhs.y == rhs.y
    }

    static func != (lhs: Coord, rhs: Coord) -> Bool
    {
      return lhs.x != rhs.x || lhs.y != rhs.y
    }
  }

  class CoordRange
  {
    let start: Coord
    let end: Coord

    init(start: Coord, end: Coord)
    {
      self.start = start
      self.end = end
    }
  }

  private var field: [[T]] = []
  let defaultValue: T
  private(set) var height: Int // For optimization purposes
  private(set) var width: Int // For optimization purposes
  private(set) var diagonalsEnabled: Bool

  init(defaultValue: T, enableDiagonals: Bool = false)
  {
    self.defaultValue = defaultValue
    self.height = 0
    self.width = 0
    self.diagonalsEnabled = enableDiagonals
  }

  func resize(to coord: Coord)
  {
    for i in 0...coord.y
    {
      if (i >= height)
      {
        field.append([])
        for _ in 0..<width
        {
          field[i].append(defaultValue)
        }
      }
    }
    height = Swift.max(height, coord.y + 1)

    for i in 0..<field.count
    {
      if (coord.x >= width)
      {
        for _ in width...coord.x
        {
          field[i].append(defaultValue)
        }
      }
    }
    width = Swift.max(width, coord.x + 1)
  }

  func setValue(_ value: T, at coord: Coord)
  {
    if (coord.y >= height || coord.x >= width)
    {
      resize(to: coord)
    }
    field[coord.y][coord.x] = value
  }

  func setRange(_ value: T, atRange range: CoordRange)
  {
    alterRange(value: value, atRange: range, withMethod: setValue)
  }

  func cutHorizontal(from index: Int)
  {
    field.removeLast(height - index)
    height = index
  }

  func cutVertical(from index: Int)
  {
    for i in field.indices
    {
      field[i].removeLast(width - index)
    }
    width = index
  }

  func getValue(at coord: Coord) -> T
  {
    return coord.isIn(field: self) ? field[coord.y][coord.x] : defaultValue
  }

  func getValue(at coord: Coord) -> T?
  {
    return coord.isIn(field: self) ? field[coord.y][coord.x] : nil
  }

  var description: String
  {
    return field.reduce(into: "")
    { (result: inout String, row: [T]) in
      result = row.reduce(into: result)
      { (result: inout String, cell: T) in
        result.append("\(cell)")
      } + "\n"
    }
  }

  func countNrOfOccurrences(where condition: (T) -> Bool) -> Int
  {
    return reduce(0)
    { (result: Int, cell: Coord) in
      return result + (condition(getValue(at: cell)) ? 1 : 0)
    }
  }

  private func alterRange(value: T, atRange range: CoordRange, withMethod alterationMethod: (T, Coord) -> Void)
  {
    assert((range.start.x == range.end.x) ||
           (range.start.y == range.end.y) ||
           (abs(range.start.x - range.end.x) == abs(range.start.y - range.end.y)),
           "horizontal, vertical, and 45 degrees diagonal supported only")

    let currentCoord: Coord = range.start
    alterationMethod(value, currentCoord)

    while currentCoord != range.end
    {
      if currentCoord.x < range.end.x
      {
        currentCoord.x += 1
      }
      else if currentCoord.x > range.end.x
      {
        currentCoord.x -= 1
      }

      if currentCoord.y < range.end.y
      {
        currentCoord.y += 1
      }
      else if currentCoord.y > range.end.y
      {
        currentCoord.y -= 1
      }

      alterationMethod(value, currentCoord)
    }
  }

  func getNeighbours(of coord: Coord, includingSelf: Bool = false) -> [Coord]
  {
    var neighbours: [Coord] = []

    if diagonalsEnabled
    {
      neighbours.append(Coord(y: coord.y-1, x: coord.x-1))
      neighbours.append(Coord(y: coord.y-1, x: coord.x))
      neighbours.append(Coord(y: coord.y-1, x: coord.x+1))

      neighbours.append(Coord(y: coord.y, x: coord.x-1))
      if includingSelf
      {
        neighbours.append(Coord(y: coord.y, x: coord.x))
      }
      neighbours.append(Coord(y: coord.y, x: coord.x+1))

      neighbours.append(Coord(y: coord.y+1, x: coord.x-1))
      neighbours.append(Coord(y: coord.y+1, x: coord.x))
      neighbours.append(Coord(y: coord.y+1, x: coord.x+1))
    }
    else
    {
      neighbours.append(Coord(y: coord.y-1, x: coord.x))
      neighbours.append(Coord(y: coord.y, x: coord.x-1))
      if includingSelf
      {
        neighbours.append(Coord(y: coord.y, x: coord.x))
      }
      neighbours.append(Coord(y: coord.y+1, x: coord.x))
      neighbours.append(Coord(y: coord.y, x: coord.x+1))
    }

    return neighbours
  }

  func getNeighbours(of coord: Coord, includingSelf: Bool = false) -> [T]
  {
    return getNeighbours(of: coord, includingSelf: includingSelf).compactMap()
    { neighbour in
      return getValue(at: neighbour)
    }
  }

  func addBox()
  {
    if width > 0 && height > 0
    {
      // Left
      for i in 0..<field.count
      {
        field[i].insert(defaultValue, at: 0)
      }
      width += 1
      // Top
      height += 1
      field.insert([T](repeating: defaultValue, count: height), at: 0)
    }
    // Right + bottom
    resize(to: Coord(y: height, x: width))
  }
}

extension Field where T: Numeric
{
  func addValue(_ value: T, at coord: Coord)
  {
    if (coord.y >= height || coord.x >= width)
    {
      resize(to: coord)
    }
    field[coord.y][coord.x] += value
  }

  func addRange(_ value: T, atRange range: CoordRange)
  {
    alterRange(value: value, atRange: range, withMethod: addValue)
  }
}

extension Field: Sequence
{
  struct Iterator: IteratorProtocol
  {
    let field: Field
    let coord: Coord

    init(_ field: Field)
    {
      self.field = field
      self.coord = Coord(y: 0, x: 0)
    }

    mutating func next() -> Coord?
    {
      let next: Coord = Coord(y: coord.y, x: coord.x)
      coord.x += 1
      if field.width == coord.x
      {
        coord.x = 0
        coord.y += 1
      }

      return field.height == next.y ? nil : next
    }
  }

  func makeIterator() -> Iterator
  {
    return Iterator(self)
  }
}
