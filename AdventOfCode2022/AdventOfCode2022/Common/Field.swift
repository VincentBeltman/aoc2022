//
//  Field.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 09/12/2022.
//

import Foundation

typealias StringField = Field<String>
typealias CharField = Field<Character>
typealias IntField = Field<Int>

class Field<T: Comparable>: CustomStringConvertible
{
  private var field: [[T]] = []
  let defaultValue: T
  private(set) var height: Int // For optimization purposes
  private(set) var width: Int // For optimization purposes
  private(set) var diagonalsEnabled: Bool
  private(set) var includingSelfInNeighbours: Bool

  init(defaultValue: T, enableDiagonals: Bool = false, includingSelfInNeighbours: Bool = false)
  {
    self.defaultValue = defaultValue
    self.height = 0
    self.width = 0
    self.diagonalsEnabled = enableDiagonals
    self.includingSelfInNeighbours = includingSelfInNeighbours
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
    toString({ "\($0)" })
  }
  func toString(_ transform: (T) -> String) -> String
  {
    return field.reduce(into: "")
    { (result: inout String, row: [T]) in
      result = row.reduce(into: result)
      { (result: inout String, cell: T) in
        result.append(transform(cell))
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

    var currentCoord: Coord = range.start
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

  func getNeighbours(of coord: Coord) -> [Coord]
  {
    var neighbours: [Coord] = []

    if diagonalsEnabled
    {
      neighbours.append(Coord(x: coord.x-1, y: coord.y-1))
      neighbours.append(Coord(x: coord.x, y: coord.y-1))
      neighbours.append(Coord(x: coord.x+1, y: coord.y-1))

      neighbours.append(Coord(x: coord.x-1, y: coord.y))
      if includingSelfInNeighbours
      {
        neighbours.append(Coord(x: coord.x, y: coord.y))
      }
      neighbours.append(Coord(x: coord.x+1, y: coord.y))

      neighbours.append(Coord(x: coord.x-1, y: coord.y+1))
      neighbours.append(Coord(x: coord.x, y: coord.y+1))
      neighbours.append(Coord(x: coord.x+1, y: coord.y+1))
    }
    else
    {
      neighbours.append(Coord(x: coord.x, y: coord.y-1))
      neighbours.append(Coord(x: coord.x-1, y: coord.y))
      if includingSelfInNeighbours
      {
        neighbours.append(Coord(x: coord.x, y: coord.y))
      }
      neighbours.append(Coord(x: coord.x, y: coord.y+1))
      neighbours.append(Coord(x: coord.x+1, y: coord.y))
    }

    return neighbours
  }

  func getNeighbours(of coord: Coord) -> [T]
  {
    return getNeighbours(of: coord).compactMap()
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
    resize(to: Coord(x: width, y: height))
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
    var coord: Coord

    init(_ field: Field)
    {
      self.field = field
      self.coord = Coord(x: 0, y: 0)
    }

    mutating func next() -> Coord?
    {
      let next: Coord = Coord(x: coord.x, y: coord.y)
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

// Dijkstra
extension Field
{
  private struct DijkstraDistance
  {
    let distance: Int
    let origin: Coord?
  }

  func dijkstra(start: Coord, isEnd: (Coord) -> Bool, isValidNeighbour: (Coord, Coord) -> Bool) -> [Coord]
  {
    var toVisit: [Coord: DijkstraDistance] = [:]
    var visited: [Coord: DijkstraDistance] = [:]
    toVisit[start] = DijkstraDistance(distance: 0, origin: nil)
    while !toVisit.isEmpty
    {
      let (currentCoord, currentDistance) = toVisit.min(by: { $0.value.distance < $1.value.distance })!
      toVisit.removeValue(forKey: currentCoord)
      visited[currentCoord] = currentDistance
      if isEnd(currentCoord)
      {
        var shortestPath: [Coord] = []
        var current: Coord? = currentCoord
        while current != nil
        {
          shortestPath.insert(current!, at: 0)
          current = visited[current!]!.origin
        }
        return shortestPath
      }
      for neighbour: Coord in getNeighbours(of: currentCoord)
      {
        guard let _ = getValue(at: neighbour) else
        { continue }
        guard visited[neighbour] == nil else
        { continue }
        let nextDistance: Int = currentDistance.distance + 1
        guard isValidNeighbour(currentCoord, neighbour) else
        { continue}
        toVisit[neighbour] = DijkstraDistance(distance: nextDistance, origin: currentCoord)
        // TODO: Needed?
        if visited[neighbour] != nil
        {
          visited[neighbour] = toVisit[neighbour]
        }
      }
    }
    fatalError()
  }
}
