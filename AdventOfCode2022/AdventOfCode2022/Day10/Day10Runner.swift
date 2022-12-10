//
//  Day10Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day10Runner: Runable
{
  func RunPart1(input: Input) -> String
  {
    let lines: [[Substring]] = input.exploded(separators: ["\n", " "])
    var registerX: Int = 1
    var cycle: Int = 1
    var result: Int = 0
    func increaseCycle()
    {
      if cycle % 40 == 20
      {
        result += registerX * cycle
      }
      cycle += 1
    }
    for line in lines
    {
      increaseCycle()
      if line[0] == "addx"
      {
        increaseCycle()
        registerX += Int(line[1])!
      }
    }
    return "\(result)"
  }

  func RunPart2(input: Input) -> String
  {
    let lines: [[Substring]] = input.exploded(separators: ["\n", " "])
    var registerX: Int = 1
    var cycle: Int = 1
    var screen: String = "\n"
    let registerRange: ClosedRange<Int> = -1...1
    func increaseCycle()
    {
      screen.append(registerRange.contains((cycle%40) - registerX-1) ? "#" : " ")
      if cycle%40 == 0
      {
        screen.append("\n")
      }
      cycle += 1
    }
    for line in lines
    {
      increaseCycle()
      if line[0] == "addx"
      {
        increaseCycle()
        registerX += Int(line[1])!
      }
    }
    return screen
  }
}
