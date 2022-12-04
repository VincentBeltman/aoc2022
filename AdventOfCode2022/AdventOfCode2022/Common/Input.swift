//
//  Input.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Input
{
  private let input: String

  init(input: String)
  {
    self.input = input
  }

  func string() -> String
  {
    return input
  }


  func exploded<R>(separators: [String]) -> R
  {
    let emptyTransform: ((Substring) -> Void)? = nil
    return exploded(separators: separators, transform: emptyTransform)
  }

  func exploded<R, S>(separators: [String], transform: ((Substring) -> S)?) -> R
  {
    func explodeList<T>(list: [Substring], separators: [String]) -> [T] where T == Array<Any>
    {
      var results: [T] = []
      let separator: String = separators.first!
      let newSeparators: [String] = separators.dropFirst().map({String($0)})
      for item in list
      {
        let subResult: [Substring] = item.split(separator: separator)
        if !newSeparators.isEmpty
        {
          results.append(explodeList(list: subResult, separators: newSeparators))
        }
        else
        {
          results.append(transform == nil ? subResult : subResult.map(transform!))
        }
      }
      return results
    }

    let separator: String = separators.first!
    let newSeparators: [String] = separators.dropFirst().map({String($0)})
    let results: [Substring] = (input).split(separator: separator)
    if !newSeparators.isEmpty
    {
      return explodeList(list: results, separators: newSeparators) as! R
    }
    return (transform == nil) ? (results as! R) : (results.map(transform!) as! R)
  }
}
