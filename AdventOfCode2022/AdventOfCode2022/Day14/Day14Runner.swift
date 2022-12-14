//
//  Day14Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day14Runner: Runable
{
  func getNeighbours(of coord: StringField.Coord) -> [StringField.Coord]
  {
    return [
      StringField.Coord(y: coord.y+1, x: coord.x), // Down
      StringField.Coord(y: coord.y+1, x: coord.x-1), // Left down diag
      StringField.Coord(y: coord.y+1, x: coord.x+1)] // Right down diag
  }
  func dropAllSand(field: StringField, sandOriginCoord: StringField.Coord) -> Int
  {
    var nrOfSand: Int = 0
    while true
    {
      var currentSandCoord: StringField.Coord = sandOriginCoord
      while true
      {
        var moved: Bool = false
        for neighbour: StringField.Coord in getNeighbours(of: currentSandCoord) where neighbour.y > currentSandCoord.y
        {
          if let value: String = field.getValue(at: neighbour)
          {
            switch value
            {
            case "#", "o":
              break
            case ".":
              moved = true
              currentSandCoord = neighbour
              break
            default:
              fatalError()
            }
          }
          else
          {
            print("Falling into the abbys")
            return nrOfSand
          }
          if moved
          { break }
        }
        if !moved
        {
          nrOfSand += 1
          field.setValue("o", at: currentSandCoord)
          if currentSandCoord == sandOriginCoord
          {
            print("Hole plugged")
            return nrOfSand
          }
          break
        }
      }
    }
  }
  func parseInput(_ input: Input) -> StringField
  {
    let lines: [[[Int]]] = input.exploded(separators: ["\n", " -> ", ","], transform: {Int($0)!})
    let field: StringField = StringField(defaultValue: ".", enableDiagonals: true)
    for line in lines
    {
      assert(line.count > 1)
      for i in 1..<line.count
      {
        let (firstCoord, SecondCoord) = (StringField.Coord(y: line[i-1][1], x: line[i-1][0]), StringField.Coord(y: line[i][1], x: line[i][0]))
        field.setRange("#", atRange: StringField.CoordRange(start: firstCoord, end: SecondCoord))
      }
    }
    return field
  }
  func RunPart1(input: Input) -> String
  {
    return "\(dropAllSand(field: parseInput(input), sandOriginCoord: StringField.Coord(y: 0, x: 500)))"
  }

  func RunPart2(input: Input) -> String
  {
    let field: StringField = parseInput(input)
    let maxY: Int = field.max(by: { $0.y < $1.y })!.y
    field.setRange("#", atRange: StringField.CoordRange(
      start: StringField.Coord(y: maxY+2, x: 0),
      end: StringField.Coord(y: maxY+2, x: 1000)))
    return "\(dropAllSand(field: field, sandOriginCoord: StringField.Coord(y: 0, x: 500)))"
  }
}
