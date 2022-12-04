//
//  Collection+CountWhere.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 04/12/2022.
//

import Foundation

extension Collection
{
  func count(where shouldCount: (Element) -> Bool) -> Int
  {
    return reduce(0)
    { (result: Int, element: Element) in
      return result + (shouldCount(element) ? 1 : 0)
    }
  }
}
