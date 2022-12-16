//
//  Graph.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 16/12/2022.
//

import Foundation

class Graph<T: Hashable>
{
  typealias ShouldGoToVertex = ([T], T) -> Bool
  private var graph: [T: [T]]
  private let shouldGoToVertex: ShouldGoToVertex?

  init()
  {
    self.graph = [:]
    self.shouldGoToVertex = nil
  }

  init(delegate: @escaping ShouldGoToVertex)
  {
    self.graph = [:]
    self.shouldGoToVertex = delegate
  }

  func addEdgeBetween(x: T, y: T)
  {
    addDirectedEdge(from: x, to: y)
    addDirectedEdge(from: y, to: x)
  }

  func addDirectedEdge(from: T, to: T)
  {
    if self.graph[from] != nil
    {
      if !self.graph[from]!.contains(to)
      {
        self.graph[from]!.append(to)
      }
      else
      {
        print("Tried to add an edge that already exists")
      }
    }
    else
    {
      self.graph[from] = [to]
    }
  }

  func getEdges(from: T) -> [T]
  {
    return self.graph[from] ?? []
  }

  func findNumberOfPaths(from: [T], to end: T) -> Int
  {
    var numberOfPaths: Int = 0
    for edge in getEdges(from: from.last!)
    {
      if edge == end
      {
        numberOfPaths += 1
      }
      else if shouldGoToVertex != nil && shouldGoToVertex!(from, edge)
      {
        var newPath: [T] = [T](from)
        newPath.append(edge)
        numberOfPaths += findNumberOfPaths(from: newPath, to: end)
      }
    }

    return numberOfPaths
  }

  func nodes() -> [T]
  {
    return Array(graph.keys)
  }

  subscript(hashable: T) -> T
  {
    for key in graph.keys where key == hashable
    {
      return key
    }
    fatalError("Called non existant key")
  }
}
