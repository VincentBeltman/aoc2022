//
//  Day2Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day2Runner: Runable
{
  enum RPS
  {
    case ROCK
    case PAPER
    case SCISSORS

    init(fromThem them: Substring)
    {
      if them == "A"
      {
        self = .ROCK
      }
      else if them == "B"
      {
        self = .PAPER
      }
      else if them == "C"
      {
        self = .SCISSORS
      }
      else
      {
        fatalError("Could not parse them \(them)")
      }
    }
    init(fromMe me: Substring)
    {
      if me == "X"
      {
        self = .ROCK
      }
      else if me == "Y"
      {
        self = .PAPER
      }
      else if me == "Z"
      {
        self = .SCISSORS
      }
      else
      {
        fatalError("Could not parse them \(me)")
      }
    }
    func choiceValue() -> Int
    {
      switch self
      {
      case .ROCK:
        return 1
      case .PAPER:
        return 2
      case .SCISSORS:
        return 3
      }
    }
    func fight(with other: RPS) -> Int
    {
      switch self
      {
      case .ROCK:
        switch other
        {
        case .ROCK:
          return 3
        case .PAPER:
          return 0
        case .SCISSORS:
          return 6
        }
      case .PAPER:
        switch other
        {
        case .ROCK:
          return 6
        case .PAPER:
          return 3
        case .SCISSORS:
          return 0
        }
      case .SCISSORS:
        switch other
        {
        case .ROCK:
          return 0
        case .PAPER:
          return 6
        case .SCISSORS:
          return 3
        }
      }
    }
    func loosingChoise() -> RPS
    {
      switch self
      {
      case .ROCK:
        return .SCISSORS
      case .PAPER:
        return .ROCK
      case .SCISSORS:
        return .PAPER
      }
    }
    func winningChoise() -> RPS
    {
      switch self
      {
      case .ROCK:
        return .PAPER
      case .PAPER:
        return .SCISSORS
      case .SCISSORS:
        return .ROCK
      }
    }
  }

  func RunPart1(input: Input) -> String
  {
    let csv: [[Substring]] = input.exploded(separators: ["\n", " "])
    var total: Int = 0
    for round in csv
    {
      let they: RPS = RPS(fromThem: round[0])
      let me: RPS = RPS(fromMe: round[1])
      total += me.fight(with: they) + me.choiceValue()
    }
    return "\(total)"
  }

  func RunPart2(input: Input) -> String
  {
    let csv: [[Substring]] = input.exploded(separators: ["\n", " "])
    var total: Int = 0
    for round in csv
    {
      let they: RPS = RPS(fromThem: round[0])
      let strat: Substring = round[1]
      if strat == "X"
      {
        total += they.loosingChoise().choiceValue()
      }
      else if strat == "Y"
      {
        total += they.choiceValue() + 3
      }
      else if strat == "Z"
      {
        total += they.winningChoise().choiceValue() + 6
      }
      else
      {
        fatalError("Could not parse them \(strat)")
      }
    }
    return "\(total)"
  }
}
