//
//  Day22Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day22Runner: Runable
{
  enum Direction: Int
  {
    case right = 0
    case down = 1
    case left = 2
    case up = 3
    func reverseDirection() -> Direction
    {
      switch self
      {
      case .up: return .down
      case .down: return .up
      case .left: return .right
      case .right: return .left
      }
    }
  }
  struct Portal: Hashable
  {
    let coord: Coord
    var direction: Direction
    func hash(into hasher: inout Hasher)
    {
      hasher.combine(coord)
      hasher.combine(direction)
    }
  }
  struct PortalDef
  {
    let coord: Coord
    let direction: Direction
    var xMod: Int = 0
    var yMod: Int = 0
    init(_ coord: Coord, _ direction: Direction, xMod: Int) { self.coord = coord; self.direction = direction; self.xMod = xMod }
    init(_ coord: Coord, _ direction: Direction, yMod: Int) { self.coord = coord; self.direction = direction; self.yMod = yMod }
  }
  typealias MoveOutOfBoundsDelegate = (inout Direction, inout Coord, IntField) -> Void
  let translations: [Coord] = [Coord(x: 1, y: 0), Coord(x: 0, y: 1), Coord(x: -1, y: 0), Coord(x: 0, y: -1)]
  func moveToOtherSide(_ rotation: inout Direction, _ currentCoord: inout Coord, _ field: IntField)
  {
    let startCoord = currentCoord
    let reversedRotation: Int = rotation.reverseDirection().rawValue
    while true
    {
      let nextCoord: Coord = Coord(x: currentCoord.x + translations[reversedRotation].x, y: currentCoord.y + translations[reversedRotation].y)
      if (field.getValue(at: nextCoord) ?? 0) == 0
      {
        if field.getValue(at: currentCoord) != 2 { currentCoord = startCoord }
        return
      }
      currentCoord = nextCoord
    }
  }

  func move(_ number: Int, _ rotation: inout Direction, _ currentCoord: inout Coord, _ field: IntField, _ moveOutOfBounds: MoveOutOfBoundsDelegate)
  {
    for _ in 1...number
    {
      let nextCoord: Coord = Coord(x: currentCoord.x + translations[rotation.rawValue].x, y: currentCoord.y + translations[rotation.rawValue].y)
      switch field.getValue(at: nextCoord) ?? nil
      {
      case 0, nil: moveOutOfBounds(&rotation, &currentCoord, field)
      case 1: break
      case 2: currentCoord = nextCoord
      default: fatalError()
      }
    }
  }

  func parseInput(_ input: Input) -> (IntField, Coord, Substring)
  {
    let parts: [Substring] = input.string().split(separator: "\n\n")
    let field: IntField = IntField(defaultValue: 0, enableDiagonals: false)
    let lines: [Substring] = parts[0].split(separator: "\n")
    for (y, line) in lines.enumerated()
    {
      for (x, char) in line.enumerated()
      {
        switch char
        {
        case " ": field.setValue(0, at: Coord(x: x, y: y))
        case "#": field.setValue(1, at: Coord(x: x, y: y))
        case ".": field.setValue(2, at: Coord(x: x, y: y))
        default: fatalError()
        }
      }
    }
    return (field, Coord(x: lines[0].map({$0}).firstIndex(of: ".")!, y: 0), parts[1])
  }
  func executeSteps(_ field: IntField, _ currentCoord: inout Coord, _ steps: Substring, _ moveToOtherFace: MoveOutOfBoundsDelegate) -> Int
  {
    var number: Int = 0
    var rotation: Direction = .right
    for step in steps
    {
      if step.isNumber { number = number*10 + step.wholeNumberValue! }
      else
      {
        move(number, &rotation, &currentCoord, field, moveToOtherFace)
        number = 0
        rotation = Direction(rawValue: step == "R" ? (rotation.rawValue < 3 ? rotation.rawValue+1 : 0) : (rotation.rawValue > 0 ? rotation.rawValue-1 : 3))!
      }
    }
    move(number, &rotation, &currentCoord, field, moveToOtherFace)
    return (1000*(currentCoord.y+1)) + (4*(currentCoord.x+1)) + rotation.rawValue
  }

  func RunPart1(input: Input) -> String
  {
    var (field, currentCoord, steps): (IntField, Coord, Substring) = parseInput(input)
    return "\(executeSteps(field, &currentCoord, steps, moveToOtherSide))"
  }

  func RunPart2(input: Input) -> String
  {
    var (field, currentCoord, steps): (IntField, Coord, Substring) = parseInput(input)
    let arm: Int = field.width / 3
    var portals: [Portal:Portal] = [:]
    func addPortals(_ portals: inout [Portal:Portal], _ a: PortalDef, _ b: PortalDef)
    {
      for i in 0..<arm
      {
        var aPortal: Portal = Portal(coord: a.coord.adding(Coord(x: a.xMod*i, y: a.yMod*i)), direction: a.direction)
        var bPortal: Portal = Portal(coord: b.coord.adding(Coord(x: b.xMod*i, y: b.yMod*i)), direction: b.direction)
        portals[aPortal] = bPortal
        aPortal.direction = aPortal.direction.reverseDirection()
        bPortal.direction = bPortal.direction.reverseDirection()
        portals[bPortal] = aPortal
      }
    }

    addPortals(&portals, PortalDef(Coord(x: arm, y: 0),         .up, xMod: 1), PortalDef(Coord(x: 0, y: arm*3),        .right, yMod:  1))
    addPortals(&portals, PortalDef(Coord(x: arm*2, y: 0),       .up, xMod: 1), PortalDef(Coord(x: 0, y: arm*4-1),         .up, xMod:  1))
    addPortals(&portals, PortalDef(Coord(x: arm, y: 0),       .left, yMod: 1), PortalDef(Coord(x: 0, y: arm*3-1),      .right, yMod: -1))
    addPortals(&portals, PortalDef(Coord(x: arm, y: arm),     .left, yMod: 1), PortalDef(Coord(x: 0, y: arm*2),         .down, xMod:  1))
    addPortals(&portals, PortalDef(Coord(x: arm*3-1, y: 0),  .right, yMod: 1), PortalDef(Coord(x: arm*2-1, y: arm*3-1), .left, yMod: -1))
    addPortals(&portals, PortalDef(Coord(x: arm*2, y: arm-1), .down, xMod: 1), PortalDef(Coord(x: arm*2-1, y: arm),     .left, yMod:  1))
    addPortals(&portals, PortalDef(Coord(x: arm, y: arm*3-1), .down, xMod: 1), PortalDef(Coord(x: arm-1, y: arm*3),     .left, yMod:  1))

    func moveToOtherFace(_ rotation: inout Direction, _ currentCoord: inout Coord, _ field: IntField)
    {
      guard let endPortal: Portal = portals[Portal(coord: currentCoord, direction: rotation)] else { fatalError() }
      guard field.getValue(at: endPortal.coord) == 2 else { return }
      rotation = endPortal.direction
      currentCoord = endPortal.coord
    }
    return "\(executeSteps(field, &currentCoord, steps, moveToOtherFace))"
  }
}
