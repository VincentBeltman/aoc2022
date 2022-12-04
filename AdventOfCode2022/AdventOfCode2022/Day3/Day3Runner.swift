//
//  Day3Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day3Runner: Runable
{
  func getDoubles(a: Substring, b: Substring) -> Set<Character>
  {
    var doubles: Set<Character> = Set()
    for ca in a
    {
      for cb in b where ca == cb
      {
        doubles.insert(cb)
      }
    }
    return doubles
  }

  func getPriority(character: Character) -> Int
  {
    return Int(character.isUppercase ? character.asciiValue! - 64 + 26 : character.asciiValue! - 96)
  }

  func RunPart1(input: Input) -> String
  {
    var total: Int = 0
    let rucksacks: [Substring] = input.exploded(separators: ["\n"])
    for rucksack in rucksacks
    {
      let numberOfItems: Int = rucksack.count/2
      total += getDoubles(
        a: rucksack.prefix(upTo: rucksack.index(rucksack.startIndex, offsetBy: numberOfItems)),
        b: rucksack.suffix(numberOfItems)
      ).reduce(0)
      { result, val in
        return result + getPriority(character: val)
      }
    }
    return "\(total)"
  }

  func RunPart2(input: Input) -> String
  {
    var total: Int = 0
    let rucksacks: [Substring] = input.exploded(separators: ["\n"])
    for i in stride(from: 0, to: rucksacks.count, by: 3)
    {
      total += getDoubles(a: rucksacks[i], b: rucksacks[i+1]).reduce(0)
      { result, val in
        return rucksacks[i+2].contains(val) ? result + getPriority(character: val) : result
      }
    }
    return "\(total)"
  }
}
