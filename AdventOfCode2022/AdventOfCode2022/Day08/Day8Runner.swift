//
//  Day8Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day8Runner: Runable
{
  struct Tree
  {
    let size: Int
    var visible: Bool = true
  }
  func RunPart1(input: Input) -> String
  {
    let lines: [Substring] = input.exploded(separators: ["\n"])
    var trees: [[Tree]] = lines.map({ $0.map({ Tree(size: Int(String($0))!) }) })
    for row in stride(from: 1, to: trees.count-1, by: 1)
    {
      for col in stride(from: 1, to: trees[row].count-1, by: 1)
      {
        // Look from up
        trees[row][col].visible = true
        for checkRow in stride(from: row-1, through: 0, by: -1)
        {
          if trees[checkRow][col].size >= trees[row][col].size
          {
            trees[row][col].visible = false
            break
          }
        }
        guard !trees[row][col].visible else
        { continue }

        // Look from down
        trees[row][col].visible = true
        for checkRow in stride(from: row+1, to: trees.count, by: 1)
        {
          if trees[checkRow][col].size >= trees[row][col].size
          {
            trees[row][col].visible = false
            break
          }
        }
        guard !trees[row][col].visible else
        { continue }

        // Look from left
        trees[row][col].visible = true
        for checkCol in stride(from: col-1, through: 0, by: -1)
        {
          if trees[row][checkCol].size >= trees[row][col].size
          {
            trees[row][col].visible = false
            break
          }
        }
        guard !trees[row][col].visible else
        { continue }

        // Look from right
        trees[row][col].visible = true
        for checkCol in stride(from: col+1, to: trees[row].count, by: 1)
        {
          if trees[row][checkCol].size >= trees[row][col].size
          {
            trees[row][col].visible = false
            break
          }
        }
      }
    }
    return "\(trees.reduce(0, { return $0 + $1.reduce(0, { return $0 + ($1.visible ? 1 : 0) }) }))"
  }

  func RunPart2(input: Input) -> String
  {
    let lines: [Substring] = input.exploded(separators: ["\n"])
    let trees: [[Tree]] = lines.map({ $0.map({ Tree(size: Int(String($0))!) }) })
    var highestScenicScore: Int = 0
    for row in stride(from: 0, to: trees.count, by: 1)
    {
      for col in stride(from: 0, to: trees[row].count, by: 1)
      {
        // Look from up
        var scenicScore: Int = 1
        var total: Int = 0
        for checkRow in stride(from: row-1, through: 0, by: -1)
        {
          total += 1
          if trees[checkRow][col].size >= trees[row][col].size
          {
            break
          }
        }
        scenicScore *= total > 0 ? total : 1

        // Look from down
        total = 0
        for checkRow in stride(from: row+1, to: trees.count, by: 1)
        {
          total += 1
          if trees[checkRow][col].size >= trees[row][col].size
          {
            break
          }
        }
        scenicScore *= total > 0 ? total : 1

        // Look from left
        total = 0
        for checkCol in stride(from: col-1, through: 0, by: -1)
        {
          total += 1
          if trees[row][checkCol].size >= trees[row][col].size
          {
            break
          }
        }
        scenicScore *= total > 0 ? total : 1

        // Look from right
        total = 0
        for checkCol in stride(from: col+1, to: trees[row].count, by: 1)
        {
          total += 1
          if trees[row][checkCol].size >= trees[row][col].size
          {
            break
          }
        }
        scenicScore *= total > 0 ? total : 1
        highestScenicScore = max(highestScenicScore, scenicScore)
      }
    }
    return "\(highestScenicScore)"
  }
}
