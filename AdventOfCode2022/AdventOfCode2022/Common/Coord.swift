//
//  Coord.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 17/12/2022.
//

import Foundation

struct Coord: Equatable, Hashable, CustomStringConvertible
{
  var x: Int
  var y: Int

  init(x: Int, y: Int)
  {
    self.x = x
    self.y = y
  }

  var description: String {
    "(\(x), \(y))"
  }

  func isIn<T>(field: Field<T>) -> Bool
  {
    return ((y >= 0) && (x >= 0) && (y < field.height) && (x < field.width))
  }

  func hash(into hasher: inout Hasher)
  {
    hasher.combine(x)
    hasher.combine(y)
  }

  func adding(_ coord: Coord) -> Coord
  {
    return Coord(x: x+coord.x, y: y+coord.y)
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
