//
//  Day12Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day12Runner: Runable
{
  func parseInput(_ input: Input) -> Field<Character>
  {
    let lines: [Substring] = input.exploded(separators: ["\n"])
    let field: Field<Character> = Field<Character>(defaultValue: "-", enableDiagonals: false)
    for (y, line) in lines.enumerated()
    {
      for (x, char) in line.enumerated()
      {
        field.setValue(char, at: Coord(x: x, y: y))
      }
    }
    return field
  }

  func RunPart1(input: Input) -> String
  {
    let field: Field<Character> = parseInput(input)
    let shortestPath: [Coord] = field.dijkstra(
      start: Coord(x: 0, y: 20),
      isEnd: { $0 == Coord(x: 58, y: 20) },
      isValidNeighbour: {Int(field.getValue(at: $0).asciiValue!) >= Int(field.getValue(at: $1).asciiValue!) - 1})
    return "\(shortestPath.count-1)"
  }

  func RunPart2(input: Input) -> String
  {
    let field: Field<Character> = parseInput(input)
    let shortestPath: [Coord] = field.dijkstra(
      start: Coord(x: 58, y: 20),
      isEnd: { field.getValue(at: $0) == "a" },
      isValidNeighbour: { (Int(field.getValue(at: $0).asciiValue!) - 1) <= Int(field.getValue(at: $1).asciiValue!) })
    return "\(shortestPath.count-1)"
  }
}
