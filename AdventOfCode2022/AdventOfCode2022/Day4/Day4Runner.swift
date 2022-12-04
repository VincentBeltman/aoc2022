//
//  Day4Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day4Runner: Runable
{
  func toRange(pair: [[Int]]) -> (ClosedRange<Int>, ClosedRange<Int>)
  {
    return (pair[0][0]...pair[0][1], pair[1][0]...pair[1][1])
  }
  func RunPart1(input: Input) -> String
  {
    let pairs: [[[Int]]] = input.exploded(separators: ["\n", ",", "-"], transform: {Int($0)!})
    return String(pairs.map(toRange).count(where: { $0.0.contains($0.1) || $0.1.contains($0.0) }))
  }
  func RunPart2(input: Input) -> String
  {
    let pairs: [[[Int]]] = input.exploded(separators: ["\n", ",", "-"], transform: {Int($0)!})
    return String(pairs.map(toRange).count(where: { $0.0.overlaps($0.1) }))
  }
}
