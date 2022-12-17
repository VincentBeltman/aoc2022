//
//  Day17Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day17Runner: Runable
{
  enum JetDirection
  {
    case left
    case right
  }
  class JetManager
  {
    let jets: [JetDirection]
    var currentJet: Int = 0
    init (raw: String)
    { jets = raw.map() { $0 == "<" ? .left : .right } }
    func getNextDirection() -> JetDirection
    {
      let nextDirection: JetDirection = jets[currentJet]
      currentJet = currentJet == jets.count-1 ? 0 : currentJet + 1
      return nextDirection
    }
  }
  struct Rock
  {
    var coords: [Coord]
    mutating func move(by moveByCoord: Coord)
    {
      for i in coords.indices
      {
        coords[i].x += moveByCoord.x
        coords[i].y += moveByCoord.y
      }
    }
  }
  class RockManager
  {
    let rocks: [Rock] = [
      Rock(coords: [Coord(x: 0, y: 0), Coord(x: 1, y: 0), Coord(x: 2, y: 0), Coord(x: 3, y: 0)]),
      Rock(coords: [Coord(x: 1, y: 0), Coord(x: 0, y: 1), Coord(x: 1, y: 1), Coord(x: 2, y: 1), Coord(x: 1, y: 2)]),
      Rock(coords: [Coord(x: 0, y: 0), Coord(x: 1, y: 0), Coord(x: 2, y: 0), Coord(x: 2, y: 1), Coord(x: 2, y: 2)]),
      Rock(coords: [Coord(x: 0, y: 0), Coord(x: 0, y: 1), Coord(x: 0, y: 2), Coord(x: 0, y: 3)]),
      Rock(coords: [Coord(x: 0, y: 0), Coord(x: 1, y: 0), Coord(x: 0, y: 1), Coord(x: 1, y: 1)])
    ]
    var currentRock: Int = 0
    func getNextRock() -> Rock
    {
      let nextRock: Rock = rocks[currentRock]
      currentRock = currentRock == rocks.count-1 ? 0 : currentRock + 1
      return nextRock
    }
  }

  struct State: Equatable
  {
    let rockIndex: Int
    let jetIndex: Int
    let heights: [Int]
    var maxHeight: Int
    static func == (lhs: Self, rhs: Self) -> Bool
    { lhs.rockIndex == rhs.rockIndex && lhs.jetIndex == rhs.jetIndex && lhs.heights == rhs.heights }
  }

  func simulateRock(field: inout [[Bool]], rockManager: RockManager, jetManager: JetManager)
  {
    var rock: Rock = rockManager.getNextRock()
    let highestIndex: Int = field.lastIndex(where: { $0.contains(true) })!
    rock.move(by: Coord(x: 2, y: highestIndex+4))
    for _ in 0..<(4-(field.count-highestIndex-1)) { field.append([Bool](repeating: false, count: 7)) }
    while true
    {
      switch jetManager.getNextDirection()
      {
      case .left:
        let canMove: Bool = rock.coords.first(where: { $0.x == 0 || ($0.y <= highestIndex && field[$0.y][$0.x-1]) }) == nil
        if canMove { rock.move(by: Coord(x: -1, y: 0)) }
      case .right:
        let canMove: Bool = rock.coords.first(where: { $0.x == 6 || ($0.y <= highestIndex && field[$0.y][$0.x+1]) }) == nil
        if canMove { rock.move(by: Coord(x: 1, y: 0)) }
      }
      let canMove: Bool = rock.coords.first(where: { $0.y < field.count && field[$0.y-1][$0.x] }) == nil
      if canMove { rock.move(by: Coord(x:0, y: -1)) }
      else
      {
        for coord in rock.coords { field[coord.y][coord.x] = true }
        break
      }
    }
  }
  func run(field: inout [[Bool]], rockManager: RockManager, jetManager: JetManager, nrOfSteps: Int = 1000000000000)
  {
    for _ in 0..<nrOfSteps { simulateRock(field: &field, rockManager: rockManager, jetManager: jetManager) }
  }

  func RunPart1(input: Input) -> String
  {
    var field: [[Bool]] = [[Bool](repeating: true, count: 7)]
    run(field: &field, rockManager: RockManager(), jetManager: JetManager(raw: input.string()), nrOfSteps: 2022)
    return "\(field.lastIndex(where: { $0.contains(true) })!)"
  }

  func RunPart2(input: Input) -> String
  {
    let jetManager: JetManager = JetManager(raw: input.string())
    let rockManager: RockManager = RockManager()
    var field: [[Bool]] = [[Bool](repeating: true, count: 7)]
    var states: [State] = []
    var interval: Int = 0
    var differenceInHeight: Int = 0
    var nrOfRocks: Int = 0
    while true // while we haven't found a cycle
    {
      let highestIndex: Int = field.lastIndex(where: { $0.contains(true) })!
      var heights: [Int] = [Int](repeating: -1, count: 7)
      for i in stride(from: highestIndex, through: 0, by: -1)
      {
        for (j, cell) in field[i].enumerated() where (heights[j] == -1 && cell) { heights[j] = highestIndex-i }
        if !heights.contains(-1) { break }
      }
      let currentState: State = State(rockIndex: rockManager.currentRock, jetIndex: jetManager.currentJet, heights: heights, maxHeight: highestIndex)
      if let index: Int = states.firstIndex(of: currentState)
      {
        differenceInHeight = currentState.maxHeight - states[index].maxHeight
        interval = nrOfRocks-index
        break
      }
      states.append(currentState)
      nrOfRocks += 1
      simulateRock(field: &field, rockManager: rockManager, jetManager: jetManager)
    }
    run(field: &field, rockManager: rockManager, jetManager: jetManager, nrOfSteps: ((1000000000000 - nrOfRocks) % interval))
    return "\(field.lastIndex(where: { $0.contains(true) })! + differenceInHeight*((1000000000000 - nrOfRocks) / interval))"
  }
}
