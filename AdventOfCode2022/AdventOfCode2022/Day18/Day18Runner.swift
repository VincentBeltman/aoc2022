//
//  Day18Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day18Runner: Runable
{
  struct Cube: Equatable, Hashable
  {
    var x: Int; var y: Int; var z: Int
    var sides: Int = 6

    static func == (lhs: Cube, rhs: Cube) -> Bool
    { lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z }
    func hash(into hasher: inout Hasher)
    { hasher.combine(x); hasher.combine(y); hasher.combine(z) }
  }

  func getMinMax(of rocks: [Cube]) -> (Cube, Cube)
  {
    return rocks.reduce(into: (Cube(x: 25, y: 25, z: 25), Cube(x: 0, y: 0, z: 0)))
    {
      $0.0.x = min($0.0.x, $1.x); $0.0.y = min($0.0.y, $1.y); $0.0.z = min($0.0.z, $1.z)
      $0.1.x = max($0.1.x, $1.x); $0.1.y = max($0.1.y, $1.y); $0.1.z = max($0.1.z, $1.z)
    }
  }

  func getNeighbours(of rock: Cube, _ minMax: (Cube, Cube)) -> [Cube]
  {
    var neighbours: [Cube] = []
    if rock.x > minMax.0.x-1 { neighbours.append(Cube(x: rock.x-1, y: rock.y  , z: rock.z  )) }
    if rock.x < minMax.1.x+1 { neighbours.append(Cube(x: rock.x+1, y: rock.y  , z: rock.z  )) }
    if rock.y > minMax.0.y-1 { neighbours.append(Cube(x: rock.x  , y: rock.y-1, z: rock.z  )) }
    if rock.y < minMax.1.y+1 { neighbours.append(Cube(x: rock.x  , y: rock.y+1, z: rock.z  )) }
    if rock.z > minMax.0.z-1 { neighbours.append(Cube(x: rock.x  , y: rock.y  , z: rock.z-1)) }
    if rock.z < minMax.1.z+1 { neighbours.append(Cube(x: rock.x  , y: rock.y  , z: rock.z+1)) }
    return neighbours
  }

  func RunPart1(input: Input) -> String
  {
    let lines: [[Int]] = input.exploded(separators: ["\n", ","], transform: { Int($0)! })
    let rocks: [Cube] = lines.map({ Cube(x: $0[0], y: $0[1], z: $0[2]) })
    let minMax = getMinMax(of: rocks)
    return "\(rocks.reduce(0, { $0 + getNeighbours(of: $1, minMax).reduce(0, { $0 + (!rocks.contains($1) ? 1 : 0) }) }))"
  }

  func RunPart2(input: Input) -> String
  {
    let lines: [[Int]] = input.exploded(separators: ["\n", ","], transform: { Int($0)! })
    let rocks: [Cube] = lines.map({ Cube(x: $0[0], y: $0[1], z: $0[2]) })
    let minMax = getMinMax(of: rocks)
    var waterCubesToVisit: Set<Cube> = Set([Cube(x: 0, y: 0, z: 0)])
    var waterCubesVisited: Set<Cube> = Set() // This will contain all water cubes surrounding the block in a giant 20x20x20 cube
    while !waterCubesToVisit.isEmpty
    {
      let rock: Cube = waterCubesToVisit.popFirst()!
      waterCubesVisited.insert(rock)
      waterCubesToVisit.formUnion(getNeighbours(of: rock, minMax).compactMap({ !rocks.contains($0) && !waterCubesVisited.contains($0) ? $0 : nil }))
    }
    return "\(rocks.reduce(0, { $0 + getNeighbours(of: $1, minMax).reduce(0, { $0 + (waterCubesVisited.contains($1) ? 1 : 0) }) }))"
  }
}
