//
//  Day16Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day16Runner: Runable
{
  class Path
  {
    struct Location: Hashable
    {
      var valveId: Int
      var openedValves: [Int]

      static func == (lhs: Day16Runner.Path.Location, rhs: Day16Runner.Path.Location) -> Bool
      { lhs.valveId == rhs.valveId && lhs.openedValves == rhs.openedValves}

      func hash(into hasher: inout Hasher)
      {
        hasher.combine(openedValves)
        hasher.combine(valveId)
      }
    }
    var currentLocation: Location
    var flowIncrement: Int = 0
    var totalFlow: Int = 0

    init(valveId: Int) { self.currentLocation = Location(valveId: valveId, openedValves: []) }
    init(valveId: Int, from other: Path)
    {
      self.currentLocation = Location(valveId: valveId, openedValves: other.currentLocation.openedValves)
      self.totalFlow = other.totalFlow
      self.flowIncrement = other.flowIncrement
    }
    init(from other: Path, adding valveId: Int, and flowRate: Int)
    {
      self.currentLocation = Location(valveId: other.currentLocation.valveId, openedValves: other.currentLocation.openedValves)
      self.currentLocation.openedValves.append(valveId)
      self.currentLocation.openedValves = self.currentLocation.openedValves.sorted()
      self.totalFlow = other.totalFlow
      self.flowIncrement = other.flowIncrement + flowRate
    }
    func hasAlreadyOpenedCurrentLocation() -> Bool
    { currentLocation.openedValves.contains(currentLocation.valveId) }
  }
  func parseInput(_ input: Input) -> ([Substring], [Int: (Int, [Int])])
  {
    let lines: [[Substring]] = input.exploded(separators: ["\n", "; "])
    var valveMap: [Substring] = []
    var graph: [Int: (Int, [Int])] = [:]
    for line: [Substring] in lines
    {
      if let valveMatch = line[0].wholeMatch(of: /Valve (.*) has flow rate=(\d+)/),
        let tunnelsMatch = line[1].wholeMatch(of: /tunnels? leads? to valves? (.*)/)
      {
        let valveId: Int = valveMap.firstIndex(of: valveMatch.1) ?? valveMap.count
        if valveId == valveMap.count { valveMap.append(valveMatch.1) }
        graph[valveId] = (Int(valveMatch.2)!, tunnelsMatch.1.split(separator: ", ").map()
          { tunnel in
            let index: Int = valveMap.firstIndex(of: tunnel) ?? valveMap.count
            if index == valveMap.count { valveMap.append(tunnel) }
            return index
          })
      } else { fatalError() }
    }
    return (valveMap, graph)
  }

  func findBestPath(nrOfMinutes: Int, valveMap: [Substring], graph: [Int: (Int, [Int])], openedValves: [Int] = []) -> Path
  {
    var paths: [Path] = [Path(valveId: valveMap.firstIndex(of: "AA")!)]
    paths[0].currentLocation.openedValves = openedValves
    var bestPaths: [Path.Location: Int] = [:]
    for _ in 1...nrOfMinutes
    {
      var newPaths: [Path] = []
      for i in paths.indices
      {
        let path: Path = paths[i]
        guard let (flowRate, tunnels) = graph[path.currentLocation.valveId] else
        { fatalError() }
        if let bestAtLocation: Int = bestPaths[path.currentLocation], bestAtLocation >= path.totalFlow
        { continue }
        bestPaths[path.currentLocation] = path.totalFlow
        path.totalFlow += path.flowIncrement
        if flowRate > 0 && !path.hasAlreadyOpenedCurrentLocation()
        { newPaths.append(Path(from: path, adding: path.currentLocation.valveId, and: flowRate)) }
        newPaths.append(contentsOf: tunnels.map({ Path(valveId: $0, from: path) }))
      }
      paths = newPaths
    }
    return paths.max(by: {$0.totalFlow < $1.totalFlow})!
  }

  func RunPart1(input: Input) -> String
  {
    let (valveMap, graph) = parseInput(input)
    let me: Path = findBestPath(nrOfMinutes: 30, valveMap: valveMap, graph: graph)
    return "\(me.totalFlow)"
  }

  func RunPart2(input: Input) -> String
  {
    let (valveMap, graph) = parseInput(input)
    let me: Path = findBestPath(nrOfMinutes: 26, valveMap: valveMap, graph: graph)
    let myLittleElliphant: Path = findBestPath(nrOfMinutes: 26, valveMap: valveMap, graph: graph, openedValves: me.currentLocation.openedValves)
    return "\(me.totalFlow + myLittleElliphant.totalFlow)"
  }
}
