//
//  Day19Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day19Runner: Runable
{
  struct Blueprint
  {
    let id: Int
    let oreRobotOreCost: Int
    let clayRobotOreCost: Int
    let obsidianRobotOreCost: Int
    let obsidianRobotClayCost: Int
    let geodeRobotOreCost: Int
    let geodeRobotObsidianCost: Int
  }
  enum Robot
  {
    case ore
    case clay
    case obsidian
    case geode
    static let nonGeode: [Robot] = [.ore, .clay, .obsidian]
  }
  struct BuildPath: Hashable
  {
    var nrOfOreRobots: Int = 1
    var nrOfOres: Int = 0
    var nrOfClayRobots: Int = 0
    var nrOfClay: Int = 0
    var nrOfObsidianRobots: Int = 0
    var nrOfObsidian: Int = 0
    var nrOfGeodeRobots: Int = 0
    var nrOfGeode: Int = 0
    mutating func mine()
    {
      nrOfOres += nrOfOreRobots
      nrOfClay += nrOfClayRobots
      nrOfObsidian += nrOfObsidianRobots
      nrOfGeode += nrOfGeodeRobots
    }
    func canBuy(_ robot: Robot, accordingTo blueprint: Blueprint) -> Bool
    {
      switch robot
      {
      case .ore:
        return nrOfOres >= blueprint.oreRobotOreCost
      case .clay:
        return nrOfOres >= blueprint.clayRobotOreCost
      case .obsidian:
        return nrOfOres >= blueprint.obsidianRobotOreCost && nrOfClay >= blueprint.obsidianRobotClayCost
      case .geode:
        return nrOfOres >= blueprint.geodeRobotOreCost && nrOfObsidian >= blueprint.geodeRobotObsidianCost
      }
    }
    mutating func buy(_ robot: Robot, using blueprint: Blueprint)
    {
      switch robot
      {
      case .ore:
        nrOfOres -= blueprint.oreRobotOreCost
        nrOfOreRobots += 1
      case .clay:
        nrOfOres -= blueprint.clayRobotOreCost
        nrOfClayRobots += 1
      case .obsidian:
        nrOfOres -= blueprint.obsidianRobotOreCost
        nrOfClay -= blueprint.obsidianRobotClayCost
        nrOfObsidianRobots += 1
      case .geode:
        nrOfOres -= blueprint.geodeRobotOreCost
        nrOfObsidian -= blueprint.geodeRobotObsidianCost
        nrOfGeodeRobots += 1
      }
    }
    func hash(into hasher: inout Hasher)
    {
      hasher.combine(nrOfOreRobots)
      hasher.combine(nrOfOres)
      hasher.combine(nrOfClayRobots)
      hasher.combine(nrOfClay)
      hasher.combine(nrOfObsidianRobots)
      hasher.combine(nrOfObsidian)
      hasher.combine(nrOfGeodeRobots)
      hasher.combine(nrOfGeode)
    }
  }
  func RunPart1(input: Input) -> String
  {
    let lines: [Substring] = input.exploded(separators: ["\n"])
    var blueprints: [Blueprint] = []
    for line in lines
    {
      if let match = line.wholeMatch(of: /Blueprint (\d+): Each ore robot costs (\d+) ore\. Each clay robot costs (\d+) ore\. Each obsidian robot costs (\d+) ore and (\d+) clay\. Each geode robot costs (\d+) ore and (\d+) obsidian\./)
      {
        blueprints.append(Blueprint(id: Int(match.1)!, oreRobotOreCost: Int(match.2)!, clayRobotOreCost: Int(match.3)!, obsidianRobotOreCost: Int(match.4)!, obsidianRobotClayCost: Int(match.5)!, geodeRobotOreCost: Int(match.6)!, geodeRobotObsidianCost: Int(match.7)!))
      }
      else
      {
        fatalError()
      }
    }

    var total: Int = 0
    for blueprint in blueprints
    {
      var buildPaths: Set<BuildPath> = Set([BuildPath()])
      var geodeMiningStarted: Bool = false
      var removeNonObsidian: Bool = false
      for j in 1...24
      {
        print(j)
        var newBuildPaths: Set<BuildPath> = Set()
        for i in buildPaths.indices
        {

          if buildPaths[i].canBuy(.geode, accordingTo: blueprint)
          {
            var newBuildPath: BuildPath = buildPaths[i]
            newBuildPath.mine()
            newBuildPath.buy(.geode, using: blueprint)
            newBuildPaths.insert(newBuildPath)
            if !geodeMiningStarted
            {
              removeNonObsidian = true
              geodeMiningStarted = true
            }
          }
          else
          {
            for robot in Robot.nonGeode where buildPaths[i].canBuy(robot, accordingTo: blueprint)
            {
              var newBuildPath: BuildPath = buildPaths[i]
              newBuildPath.mine()
              newBuildPath.buy(robot, using: blueprint)
              newBuildPaths.insert(newBuildPath)
            }
            var newBuildPath: BuildPath = buildPaths[i]
            newBuildPath.mine()
            newBuildPaths.insert(newBuildPath)
          }
        }
        if removeNonObsidian
        {
          buildPaths = Set(newBuildPaths.sorted(by: { $0.nrOfGeode + $0.nrOfGeodeRobots > $1.nrOfGeode + $1.nrOfGeodeRobots })[0..<min(100000, newBuildPaths.count)])
        }
        else
        {
          buildPaths = newBuildPaths
        }
      }
      let maxPath: BuildPath = buildPaths.max(by: { $0.nrOfGeode < $1.nrOfGeode })!
      total += maxPath.nrOfGeode * blueprint.id
      print(total)
    }

    return "\(total)"
  }

  func RunPart2(input: Input) -> String
  {
    let lines: [Substring] = input.exploded(separators: ["\n"])
    var blueprints: [Blueprint] = []
    for line in lines
    {
      if let match = line.wholeMatch(of: /Blueprint (\d+): Each ore robot costs (\d+) ore\. Each clay robot costs (\d+) ore\. Each obsidian robot costs (\d+) ore and (\d+) clay\. Each geode robot costs (\d+) ore and (\d+) obsidian\./)
      {
        blueprints.append(Blueprint(id: Int(match.1)!, oreRobotOreCost: Int(match.2)!, clayRobotOreCost: Int(match.3)!, obsidianRobotOreCost: Int(match.4)!, obsidianRobotClayCost: Int(match.5)!, geodeRobotOreCost: Int(match.6)!, geodeRobotObsidianCost: Int(match.7)!))
      }
      else
      {
        fatalError()
      }
    }

    var total: [Int] = []
    for b in 0..<3
    {
      let blueprint: Blueprint = blueprints[b]
      var buildPaths: Set<BuildPath> = Set([BuildPath()])
      var geodeMiningStarted: Bool = false
      var removeNonObsidian: Bool = false
      for j in 1...32
      {
        print(j)
        var newBuildPaths: Set<BuildPath> = Set()
        for i in buildPaths.indices
        {

          if buildPaths[i].canBuy(.geode, accordingTo: blueprint)
          {
            var newBuildPath: BuildPath = buildPaths[i]
            newBuildPath.mine()
            newBuildPath.buy(.geode, using: blueprint)
            newBuildPaths.insert(newBuildPath)
            if !geodeMiningStarted
            {
              removeNonObsidian = true
              geodeMiningStarted = true
            }
          }
          else
          {
            for robot in Robot.nonGeode where buildPaths[i].canBuy(robot, accordingTo: blueprint)
            {
              var newBuildPath: BuildPath = buildPaths[i]
              newBuildPath.mine()
              newBuildPath.buy(robot, using: blueprint)
              newBuildPaths.insert(newBuildPath)
            }
            var newBuildPath: BuildPath = buildPaths[i]
            newBuildPath.mine()
            newBuildPaths.insert(newBuildPath)
          }
        }
        if removeNonObsidian
        {
          buildPaths = Set(newBuildPaths.sorted(by: { $0.nrOfGeode + $0.nrOfGeodeRobots > $1.nrOfGeode + $1.nrOfGeodeRobots })[0..<min(100000, newBuildPaths.count)])
        }
        else
        {
          buildPaths = newBuildPaths
        }
      }
      let maxPath: BuildPath = buildPaths.max(by: { $0.nrOfGeode < $1.nrOfGeode })!
      total.append(maxPath.nrOfGeode)
    }

    return "\(total.reduce(1, *))"
  }
}
