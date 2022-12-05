//
//  Day5Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day5Runner: Runable
{
  func RunPart1(input: Input) -> String
  {
    let lines: [[Substring]] = input.exploded(separators: ["\n\n", "\n"])
    var (stackLines, instructions) = (lines[0], lines[1])
    stackLines.removeLast()
    var stacks: [Int: [String]] = [:]
    for line in stackLines
    {
      for i in stride(from: 0, to: line.count, by: 4) where line[line.index(line.startIndex, offsetBy: i)] == "[" && line[line.index(line.startIndex, offsetBy: i+2)] == "]"
      {
        if stacks[i/4+1] == nil
        {
          stacks[i/4+1] = []
        }
        stacks[i/4+1]!.append(String(line[line.index(line.startIndex, offsetBy: i+1)]))
      }
    }

    for instruction in instructions
    {
      if let match = instruction.wholeMatch(of: /move (\d+) from (\d+) to (\d+)/)
      {
        let (steps, from, to) = (Int(match.1)!, Int(match.2)!, Int(match.3)!)
        for crate in stacks[from]![0..<steps]
        {
          stacks[to]!.insert(crate, at: 0)
        }
        stacks[from]!.removeFirst(steps)
      }
    }

    return stacks.keys.sorted().reduce(into: "") { $0.append(stacks[$1]![0]) }
  }

  func RunPart2(input: Input) -> String
  {
    let lines: [[Substring]] = input.exploded(separators: ["\n\n", "\n"])
    var (stackLines, instructions) = (lines[0], lines[1])
    stackLines.removeLast()
    var stacks: [Int: [String]] = [:]
    for line in stackLines
    {
      for i in stride(from: 0, to: line.count, by: 4) where line[line.index(line.startIndex, offsetBy: i)] == "[" && line[line.index(line.startIndex, offsetBy: i+2)] == "]"
      {
        if stacks[i/4+1] == nil
        {
          stacks[i/4+1] = []
        }
        stacks[i/4+1]!.append(String(line[line.index(line.startIndex, offsetBy: i+1)]))
      }
    }

    for instruction in instructions
    {
      if let match = instruction.wholeMatch(of: /move (\d+) from (\d+) to (\d+)/)
      {
        let (steps, from, to) = (Int(match.1)!, Int(match.2)!, Int(match.3)!)
        for (i, crate) in stacks[from]![0..<steps].enumerated()
        {
          stacks[to]!.insert(crate, at: i)
        }
        stacks[from]!.removeFirst(steps)
      }
    }

    return stacks.keys.sorted().reduce(into: "") { $0.append(stacks[$1]![0]) }
  }
}
