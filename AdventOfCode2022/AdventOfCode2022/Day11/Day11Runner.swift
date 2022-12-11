//
//  Day11Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day11Runner: Runable
{
  class Monkey
  {
    var items: [Int]
    let inspectOperation: (Int) -> Int
    let testDivisor: Int
    let trueMonkey: Int
    let falseMonkey: Int
    var numberOfInspectedItems: Int

    init(items: [Int], inspectOperation: @escaping (Int) -> Int, testDivisor: Int, trueMonkey: Int, falseMonkey: Int)
    {
      self.items = items
      self.inspectOperation = inspectOperation
      self.testDivisor = testDivisor
      self.trueMonkey = trueMonkey
      self.falseMonkey = falseMonkey
      self.numberOfInspectedItems = 0
    }

    func inspectItems(throwTo monkeys: inout [Monkey], worryFixer: (Int) -> Int = { $0 / 3 })
    {
      numberOfInspectedItems += items.count
      for i in items.indices
      {
        items[i] = worryFixer(inspectOperation(items[i]))
        if items[i] % testDivisor == 0
        {
          monkeys[trueMonkey].items.append(items[i])
        }
        else
        {
          monkeys[falseMonkey].items.append(items[i])
        }
      }
      items.removeAll()
    }
  }
  func parseMonkey(_ rawMonkey: [[Substring]]) -> Monkey
  {
    let (items, operation, test, trueAction, falseAction) = (rawMonkey[1], rawMonkey[2], rawMonkey[3], rawMonkey[4], rawMonkey[5])
    var inspectOperation: (Int) -> Int = { _ in fatalError() }
    if operation[5] == "old"
    {
      inspectOperation = operation[4] == "*" ? { $0 * $0 } : { $0 + $0 }
    }
    else
    {
      inspectOperation = operation[4] == "*" ? { $0 * Int(operation[5])! } : { $0 + Int(operation[5])! }
    }
    return Monkey(
      items: items.dropFirst(2).map({ Int($0.trimmingCharacters(in: CharacterSet(charactersIn: ",")))! }),
      inspectOperation: inspectOperation,
      testDivisor: Int(test[3])!,
      trueMonkey: Int(trueAction[5])!,
      falseMonkey: Int(falseAction[5])!
    )
  }
  func RunPart1(input: Input) -> String
  {
    let rawMonkeys: [[[Substring]]] = input.exploded(separators: ["\n\n", "\n", " "])
    var monkeys: [Monkey] = rawMonkeys.map(parseMonkey)
    for _ in 1...20
    {
      for monkeyIndex in monkeys.indices
      {
        monkeys[monkeyIndex].inspectItems(throwTo: &monkeys)
      }
    }

    let sorted = monkeys.sorted(by: { $0.numberOfInspectedItems > $1.numberOfInspectedItems } )

    return "\(sorted[0].numberOfInspectedItems * sorted[1].numberOfInspectedItems)"
  }

  struct Item
  {
    var worryLevel: Int
    var monkeyIndex: Int
  }

  func RunPart2(input: Input) -> String
  {
    let rawMonkeys: [[[Substring]]] = input.exploded(separators: ["\n\n", "\n", " "])
    var monkeys: [Monkey] = rawMonkeys.map(parseMonkey)
    let commonTestFactor: Int = monkeys.reduce(1, { $0 * $1.testDivisor })
    for _ in 1...10000
    {
      for monkeyIndex in monkeys.indices
      {
        monkeys[monkeyIndex].inspectItems(throwTo: &monkeys)
        { worryLevel in
          return worryLevel % commonTestFactor
        }
      }
    }

    let sorted = monkeys.sorted(by: { $0.numberOfInspectedItems > $1.numberOfInspectedItems } )

    return "\(sorted[0].numberOfInspectedItems * sorted[1].numberOfInspectedItems)"
  }
}
