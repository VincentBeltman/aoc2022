//
//  Day23Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day23Runner: Runable
{
  enum Direction
  {
    case up
    case down
    case left
    case right

    func getNeighbours(of coord: Coord) -> [Coord]
    {
      switch self
      {
      case .up:    return [Coord(x: coord.x-1, y: coord.y-1), Coord(x: coord.x  , y: coord.y-1), Coord(x: coord.x+1, y: coord.y-1)]
      case .down:  return [Coord(x: coord.x-1, y: coord.y+1), Coord(x: coord.x  , y: coord.y+1), Coord(x: coord.x+1, y: coord.y+1)]
      case .left:  return [Coord(x: coord.x-1, y: coord.y-1), Coord(x: coord.x-1, y: coord.y  ), Coord(x: coord.x-1, y: coord.y+1)]
      case .right: return [Coord(x: coord.x+1, y: coord.y-1), Coord(x: coord.x+1, y: coord.y  ), Coord(x: coord.x+1, y: coord.y+1)]
      }
    }
    func move(_ elf: Coord) -> Coord
    {
      switch self
      {
      case .up:    return Coord(x: elf.x  , y: elf.y-1)
      case .down:  return Coord(x: elf.x  , y: elf.y+1)
      case .left:  return Coord(x: elf.x-1, y: elf.y  )
      case .right: return Coord(x: elf.x+1, y: elf.y  )
      }
    }
  }
  struct Elf
  {
    var currentCoord: Coord
    var nextCoord: Coord
    init(coord: Coord) { self.currentCoord = coord; self.nextCoord = coord }
    mutating func move() { currentCoord = nextCoord }
  }
  func parseInput(_ input: Input) -> [Elf]
  {
    var elves: [Elf] = []
    for (y, line) in input.string().split(separator: "\n").enumerated()
    {
      for (x, char) in line.enumerated() where char == "#"
      { elves.append(Elf(coord: Coord(x: x, y: y))) }
    }
    return elves
  }

  func step(_ elves: inout [Elf], _ directions: inout [Direction]) -> Bool
  {
    var doubleCoords: Set<Coord> = Set()
    var noElvesMoved: Bool = true
    for i in elves.indices
    {
      let availableDirections: [Direction] = directions.compactMap({
        !$0.getNeighbours(of: elves[i].currentCoord).contains(where: { a in elves.contains(where: { b in a == b.currentCoord } ) }) ? $0 : nil
      })
      if availableDirections.count < 4 && availableDirections.count > 0
      {
        noElvesMoved = false
        let nextCoord: Coord = availableDirections.first!.move(elves[i].currentCoord)
        if elves.contains(where: { $0.nextCoord == nextCoord })
        { doubleCoords.insert(nextCoord) }
        else { elves[i].nextCoord = nextCoord }
      }
    }
    for (i, elf) in elves.enumerated()
    {
      if doubleCoords.contains(elf.nextCoord) { elves[i].nextCoord = elf.currentCoord }
      else { elves[i].currentCoord = elf.nextCoord }
    }
    directions.append(directions.removeFirst())
    return noElvesMoved
  }

  func RunPart1(input: Input) -> String
  {
    var elves: [Elf] = parseInput(input)
    var directions: [Direction] = [.up, .down, .left, .right]
    for _ in 0..<10 { _ = step(&elves, &directions) }
    var minX = 0; var maxX = 0
    var minY = 0; var maxY = 0
    for elf in elves
    {
      minX = min(minX, elf.currentCoord.x); maxX = max(maxX, elf.currentCoord.x)
      minY = min(minY, elf.currentCoord.y); maxY = max(maxY, elf.currentCoord.y)
    }
    return "\((maxX-minX+1)*(maxY-minY+1) - elves.count)"
  }

  func RunPart2(input: Input) -> String
  {
    var elves: [Elf] = parseInput(input)
    var directions: [Direction] = [.up, .down, .left, .right]
    var steps: Int = 1
    while !step(&elves, &directions)
    {
      steps += 1
    }
    return "\(steps)"
  }
}
