//
//  Day25Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day25Runner: Runable
{
  func snafuToInt(_ snafu: Character) -> Int
  {
    switch snafu
    {
    case "2": return 2
    case "1": return 1
    case "0": return 0
    case "-": return -1
    case "=": return -2
    default: fatalError()
    }
  }
  func intToSnafu(_ number: Int) -> String
  {
    var toParse: Int = number
    var result: String = ""
    var carry: Int = 0
    while toParse > 0
    {
      let digit: Int = (carry + toParse)%5
      toParse += carry
      toParse /= 5
      if digit == 4 { result.append("-"); carry = 1 }
      else if digit == 3 { result.append("="); carry = 1 }
      else { result.append("\(digit)"); carry = 0 }
    }
    if carry == 1 { result.append("1") }
    return String(result.reversed())
  }

  func RunPart1(input: Input) -> String
  {
    let result: Int = input.string().split(separator: "\n").reduce(0, { a, b in a + b.reduce(0, { $0*5 + snafuToInt($1) }) })
    return intToSnafu(result)
  }

  func RunPart2(input: Input) -> String
  {
    return ""
  }
}
