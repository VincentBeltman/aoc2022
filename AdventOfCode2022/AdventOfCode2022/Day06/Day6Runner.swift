//
//  Day6Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day6Runner: Runable
{
  func run(input: Input, n: Int) -> String
  {
    let inputString: [Character] = input.string().map({$0})
    func insertInSet(set: inout Set<Character>, insertFrom index: Int) { set.insert(inputString[index]) }
    for i in 0..<inputString.count-n where [Int](i..<i+n).reduce(into: Set(), insertInSet).count == n
    {
      return "\(i+n)"
    }
    return ""
  }
  func RunPart1(input: Input) -> String
  {
    return run(input: input, n: 4)
  }

  func RunPart2(input: Input) -> String
  {
    return run(input: input, n: 14)
  }
}
