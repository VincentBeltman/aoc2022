//
//  Day20Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day20Runner: Runable
{
  class Node
  {
    var left: Node!
    var right: Node!
    let number: Int
    init (left: Node?, right: Node?, number: Int)
    {
      self.left = left
      self.right = right
      self.number = number
    }
    func getNode(at indexFromSelf: Int) -> Node
    {
      if indexFromSelf > 0 { return right.getNode(at: indexFromSelf-1) }
      if indexFromSelf < 0 { return left.getNode(at: indexFromSelf+1) }
      return self
    }
  }
  func parseNodes(input: Input) -> [Node]
  {
    var numbers: [Int] = input.exploded(separators: ["\n"], transform: { Int($0)! })
    var lastNode: Node = Node(left: nil, right: nil, number: numbers.removeFirst())
    var nodes: [Node] = [lastNode]
    nodes.append(contentsOf: numbers.map({
      let newNode: Node = Node(left: lastNode, right: nil, number: $0)
      lastNode.right = newNode
      lastNode = newNode
      return newNode
    }))
    nodes.first!.left = lastNode
    lastNode.right = nodes.first!
    return nodes
  }
  func mix(_ nodes: inout [Node])
  {
    for i in nodes.indices
    {
      let node: Node = nodes[i]
      if node.number > 0
      { // Move right
        node.right.left = node.left; node.left.right = node.right // Remove self from current position
        let target: Node = node.getNode(at: node.number%(nodes.count-1))
        node.left = target; node.right = target.right // Place self after target
        target.right = node; node.right.left = node // Repair new neighbours
      }
      else if node.number < 0
      { // Move left
        node.right.left = node.left; node.left.right = node.right // Remove self from current position
        let target: Node = node.getNode(at: node.number%(nodes.count-1))
        node.right = target; node.left = target.left // Place self after target
        target.left = node; node.left.right = node // Repair new neighbours
      } // Skip if number is 0
    }
  }
  func RunPart1(input: Input) -> String
  {
    var nodes: [Node] = parseNodes(input: input)
    mix(&nodes)
    return "\([Int](1...3).reduce(0, { $0 + nodes.first(where: { $0.number == 0 })!.getNode(at: ($1*1000) % nodes.count).number } ))"
  }

  func RunPart2(input: Input) -> String
  {
    var nodes: [Node] = parseNodes(input: input)
    for _ in 1...10 { mix(&nodes) }
    return "\([Int](1...3).reduce(0, { $0 + nodes.first(where: { $0.number == 0 })!.getNode(at: ($1*1000) % nodes.count).number } ))"
  }
}
