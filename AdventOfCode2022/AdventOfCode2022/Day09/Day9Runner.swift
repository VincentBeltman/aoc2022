//
//  Day9Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day9Runner: Runable
{
  struct Coord: Hashable
  {
    var x: Int
    var y: Int
    mutating func add(_ coordDiff: Coord)
    {
      x += coordDiff.x
      y += coordDiff.y
    }
    func diff(_ other: Coord) -> Coord
    {
      return Coord(x: x - other.x, y: y - other.y)
    }
  }
  func compareTo0(_ number: Int) -> Int
  {
    if number >= 1
    {
      return 1
    }
    return number <= -1 ? -1 : 0
  }
  func RunPart1(input: Input) -> String
  {
    let steps: [[Substring]] = input.exploded(separators: ["\n", " "])
    var head: Coord = Coord(x: 0, y: 0)
    var tail: Coord = head
    var visited: Set<Coord> = Set()
    visited.insert(head)

    func doStep(numberOfSteps: Int, direction: Coord)
    {
      for _ in 0..<numberOfSteps
      {
        head.add(direction)
        let diff: Coord = head.diff(tail)
        tail.add(diff.x > 1 || diff.x < -1 || diff.y > 1 || diff.y < -1 ? Coord(x: compareTo0(diff.x), y: compareTo0(diff.y)) : Coord(x: 0, y: 0))
        visited.insert(tail)
      }
    }
    for step in steps
    {
      let (direction, numberOfSteps): (Substring, Int) = (step[0], Int(step[1])!)
      switch direction
      {
      case "U":
        doStep(numberOfSteps: numberOfSteps, direction: Coord(x: 0, y: -1))
      case "D":
        doStep(numberOfSteps: numberOfSteps, direction: Coord(x: 0, y: 1))
      case "L":
        doStep(numberOfSteps: numberOfSteps, direction: Coord(x: -1, y: 0))
      case "R":
        doStep(numberOfSteps: numberOfSteps, direction: Coord(x: 1, y: 0))
      default:
        fatalError("Could not parse direction")
      }
    }
    return "\(visited.count)"
  }

  func RunPart2(input: Input) -> String
  {
    let steps: [[Substring]] = input.exploded(separators: ["\n", " "])
    var rope: [Coord] = [Int](0..<10).map({ _ in return Coord(x: 0, y: 0) })
    var visited: Set<Coord> = Set()
    visited.insert(rope[9])

    func doStep(numberOfSteps: Int, direction: Coord)
    {
      for _ in 0..<numberOfSteps
      {
        var nextDirection: Coord = direction
        for i in rope.indices where i < 9 // skip last
        {
          rope[i].add(nextDirection)
          let diff: Coord = rope[i].diff(rope[i+1])
          nextDirection = diff.x > 1 || diff.x < -1 || diff.y > 1 || diff.y < -1 ? Coord(x: compareTo0(diff.x), y: compareTo0(diff.y)) : Coord(x: 0, y: 0)
        }
        rope[9].add(nextDirection)
        visited.insert(rope[9])
      }
    }
    for step in steps
    {
      let (direction, numberOfSteps): (Substring, Int) = (step[0], Int(step[1])!)
      switch direction
      {
      case "U":
        doStep(numberOfSteps: numberOfSteps, direction: Coord(x: 0, y: -1))
      case "D":
        doStep(numberOfSteps: numberOfSteps, direction: Coord(x: 0, y: 1))
      case "L":
        doStep(numberOfSteps: numberOfSteps, direction: Coord(x: -1, y: 0))
      case "R":
        doStep(numberOfSteps: numberOfSteps, direction: Coord(x: 1, y: 0))
      default:
        fatalError("Could not parse direction")
      }
    }
    return "\(visited.count)"
  }
}
