//
//  Day24Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day24Runner: Runable
{
  struct Blizzard
  {
    enum Direction
    {
      case up
      case down
      case left
      case right
    }
    var coord: Coord
    let direction: Direction
    mutating func move(in field: CharField)
    {
      switch direction
      {
      case .up:    coord.y = (coord.y == 1)              ? field.height-2 : coord.y-1
      case .down:  coord.y = (coord.y == field.height-2) ? 1              : coord.y+1
      case .left:  coord.x = (coord.x == 1)              ? field.width-2  : coord.x-1
      case .right: coord.x = (coord.x == field.width-2)  ? 1              : coord.x+1
      }
    }
  }

  func parseInput(_ input: Input) -> (CharField, [Blizzard])
  {
    let field: CharField = CharField(defaultValue: ".", enableDiagonals: false, includingSelfInNeighbours: true)
    for (y, line) in input.string().split(separator: "\n").enumerated()
    {
      for (x, char) in line.enumerated() { field.setValue(char, at: Coord(x: x, y: y)) }
    }
    let blizzards: [Blizzard] = field.compactMap({
      switch field.getValue(at: $0)!
      {
      case "^": return Blizzard(coord: $0, direction: .up)
      case "v": return Blizzard(coord: $0, direction: .down)
      case "<": return Blizzard(coord: $0, direction: .left)
      case ">": return Blizzard(coord: $0, direction: .right)
      default: return nil
      }
    })
    return (field, blizzards)
  }

  func traverse(field: CharField, blizzards: inout [Blizzard], start: Coord, end: Coord) -> Int
  {
    var coords: Set<Coord> = Set([start])
    var nrOfSteps: Int = 0
    while true
    {
      nrOfSteps += 1
      for i in blizzards.indices { blizzards[i].move(in: field) }
      var newCoords: Set<Coord> = Set()
      for coord in coords
      {
        for neighbour: Coord in field.getNeighbours(of: coord)
        {
          guard let value = field.getValue(at: neighbour) else { continue }
          guard value != "#" else { continue }
          guard !blizzards.contains(where: { $0.coord == neighbour }) else { continue }
          if neighbour == end
          {
            return nrOfSteps
          }
          newCoords.insert(neighbour)
        }
      }
      coords = newCoords
    }
  }

  func RunPart1(input: Input) -> String
  {
    var (field, blizzards): (CharField, [Blizzard]) = parseInput(input)
    let start: Coord = Coord(x: 1, y: 0)
    let end: Coord = Coord(x: field.width-2, y: field.height-1)
    return "\(traverse(field: field, blizzards: &blizzards, start: start, end: end))"
  }

  func RunPart2(input: Input) -> String
  {
    var (field, blizzards): (CharField, [Blizzard]) = parseInput(input)
    let start: Coord = Coord(x: 1, y: 0)
    let end: Coord = Coord(x: field.width-2, y: field.height-1)
    var total: Int = traverse(field: field, blizzards: &blizzards, start: start, end: end)
    total += traverse(field: field, blizzards: &blizzards, start: end, end: start)
    total += traverse(field: field, blizzards: &blizzards, start: start, end: end)
    return "\(total)"
  }
}
