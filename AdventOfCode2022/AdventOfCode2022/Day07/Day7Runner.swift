//
//  Day7Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day7Runner: Runable
{
  class Node
  {
    enum FileType
    {
      case dir
      case file
    }

    let name: Substring
    let type: FileType
    let fileSize: Int?
    var nodes: [Node] = []
    let parent: Node?

    init(name: Substring, type: FileType, parent: Node?, fileSize: Int? = nil)
    {
      self.name = name
      self.type = type
      self.fileSize = fileSize
      self.parent = parent
    }

    func getSize() -> Int
    {
      switch type
      {
      case .dir:
        return self.nodes.reduce(0, { return $0 + $1.getSize() })
      case .file:
        return fileSize!
      }
    }

    func getTotal(limit: Int) -> Int
    {
      let size: Int = getSize()
      return (size <= limit ? size : 0) + nodes.filter({ $0.type == .dir }).reduce(0, { return $0 + $1.getTotal(limit: limit) })
    }
    func getSmallestDir(biggerThen: Int) -> Int
    {
      return nodes.filter({ $0.type == .dir }).reduce(70000000)
      { currentSmallest, dir in
        let smallestInnerDir: Int = dir.getSmallestDir(biggerThen: biggerThen)
        let size: Int = min(dir.getSize(), smallestInnerDir)
        return size > biggerThen ? min(size, currentSmallest) : currentSmallest
      }
    }
  }
  func parseInput(input: Input) -> Node
  {
    let lines: [[Substring]] = input.exploded(separators: ["\n"," "])
    var rootDir: Node?
    var currentDir: Node?
    for line in lines
    {
      if line[0] == "$"
      {
        if line[1] == "cd"
        {
          if rootDir == nil
          {
            rootDir = Node(name: line[2], type: .dir, parent: nil)
            currentDir = rootDir
          }
          else
          {
            currentDir = line[2] == ".." ? currentDir!.parent! : currentDir!.nodes.first(where: { $0.name == line[2] })!
          }
        }
      }
      else
      {
        if line[0] == "dir"
        {
          currentDir!.nodes.append(Node(name: line[1], type: .dir, parent: currentDir))
        }
        else
        {
          currentDir!.nodes.append(Node(name: line[1], type: .file, parent: currentDir, fileSize: Int(line[0])!))
        }
      }
    }
    return rootDir!
  }
  func RunPart1(input: Input) -> String
  {
    return "\(parseInput(input: input).getTotal(limit: 100000))"
  }

  func RunPart2(input: Input) -> String
  {
    let root: Node = parseInput(input: input)
    return "\(root.getSmallestDir(biggerThen: 30000000 - (70000000 - root.getSize())))"
  }
}
