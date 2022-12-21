//
//  Day21Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day21Runner: Runable
{
  class Monkey
  {
    var name: Substring
    var number: Int?
    var firstMonkey: Monkey?
    var secondMonkey: Monkey?
    var parentMonkey: Monkey?
    var operation: Substring?
    init(name: Substring)
    {
      self.name = name
    }
    func tryCalcNumber()
    {
      guard let firstNumber = firstMonkey?.number, let secondNumber = secondMonkey?.number else { return }
      switch operation
      {
      case "+": number = firstNumber + secondNumber
      case "-": number = firstNumber - secondNumber
      case "*": number = firstNumber * secondNumber
      case "/": number = firstNumber / secondNumber
      case "=": break
      default: fatalError()
      }
    }
    func calcExpectedNumber(_ old: Int? = nil) -> Int
    {
      let firstIsSet: Bool = firstMonkey?.number != nil
      switch operation
      {
      case "+": return firstIsSet ? secondMonkey!.calcExpectedNumber(old! - firstMonkey!.number!) : firstMonkey!.calcExpectedNumber(old! - secondMonkey!.number!)
      case "-": return firstIsSet ? secondMonkey!.calcExpectedNumber(firstMonkey!.number! - old!) : firstMonkey!.calcExpectedNumber(old! + secondMonkey!.number!)
      case "*": return firstIsSet ? secondMonkey!.calcExpectedNumber(old! / firstMonkey!.number!) : firstMonkey!.calcExpectedNumber(old! / secondMonkey!.number!)
      case "/": return firstIsSet ? secondMonkey!.calcExpectedNumber(firstMonkey!.number! / old!) : firstMonkey!.calcExpectedNumber(old! * secondMonkey!.number!)
      case "=": return firstIsSet ? secondMonkey!.calcExpectedNumber(firstMonkey!.number!) : firstMonkey!.calcExpectedNumber(secondMonkey!.number!)
      default: return old!
      }
    }
  }
  func parseInput(_ input: Input) -> [Monkey]
  {
    let lines: [[Substring]] = input.exploded(separators: ["\n",": "])
    var monkeys: [Monkey] = []
    for line in lines
    {
      var monkey: Monkey? = monkeys.first(where: { $0.name == line[0] })
      if monkey == nil { monkey = Monkey(name: line[0]); monkeys.append(monkey!) }
      let monkeyScream: [Substring] = line[1].split(separator: " ")
      if monkeyScream.count == 1 { monkey!.number =  Int(monkeyScream[0])! }
      else
      {
        monkey!.firstMonkey = monkeys.first(where: { $0.name == monkeyScream[0] })
        if monkey!.firstMonkey == nil { monkey!.firstMonkey = Monkey(name: monkeyScream[0]); monkeys.append(monkey!.firstMonkey!) }
        monkey!.secondMonkey = monkeys.first(where: { $0.name == monkeyScream[2] })
        if monkey!.secondMonkey == nil { monkey!.secondMonkey = Monkey(name: monkeyScream[2]); monkeys.append(monkey!.secondMonkey!) }
        monkey!.operation =  monkeyScream[1]
        monkey!.firstMonkey!.parentMonkey = monkey
        monkey!.secondMonkey!.parentMonkey = monkey
      }
    }
    return monkeys
  }

  func RunPart1(input: Input) -> String
  {
    var monkeys: [Monkey] = parseInput(input)
    let root: Monkey = monkeys.first(where: { $0.name == "root" })!
    while root.number == nil
    {
      let remove: [Int] = monkeys.enumerated().compactMap({ $0.element.number != nil ? $0.offset : nil }) // Find monkeys with a number
      for i in remove.reversed() { monkeys.remove(at: i).parentMonkey!.tryCalcNumber() } // Remove and update parent monkey
    }
    return "\(root.number!)"
  }

  func RunPart2(input: Input) -> String
  {
    var monkeys: [Monkey] = parseInput(input)
    var previousCount: Int = 0
    let root: Monkey = monkeys.first(where: { $0.name == "root" })!
    root.operation = "="
    monkeys.first(where: { $0.name == "humn" })!.number = nil
    while monkeys.count != previousCount
    {
      previousCount = monkeys.count
      let remove: [Int] = monkeys.enumerated().compactMap({ $0.element.number != nil ? $0.offset : nil }) // Find monkeys with a number
      for i in remove.reversed() { monkeys.remove(at: i).parentMonkey!.tryCalcNumber() } // Remove and update parent monkey
    }
    let result =  "\(root.calcExpectedNumber())"
    return result
  }
}
