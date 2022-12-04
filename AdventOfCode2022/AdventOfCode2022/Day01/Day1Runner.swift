//
//  Day1Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day1Runner: Runable
{
  func RunPart1(input: Input) -> String
  {
    let csv: [[Substring]] = input.exploded(separators: ["\n\n", "\n"])
    var max: Int = 0
    for elf in csv
    {
      var total: Int = 0
      for val in elf
      {
        total += Int(val)!
      }
      max = total > max ? total : max
    }
    return "\(max)"
  }

  func RunPart2(input: Input) -> String
  {
    let csv: [[Substring]] = input.exploded(separators: ["\n\n", "\n"])
    var elfs: [Int] = []
    for raw in csv
    {
      let total: Int = raw.reduce(0)
      { (res, val) in
        return res + Int(val)!
      }
      let (insertIndex, _) = elfs.enumerated().first(where: {$0.element < total}) ?? (elfs.count, 0)
      elfs.insert(total, at: insertIndex)
    }

    return "\(elfs[0] + elfs[1] + elfs[2])"
  }
}
