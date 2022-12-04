//
//  Runable.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

protocol Runable
{
  func Derived() -> any Runable
  func RunPart1(input: Input) -> String
  func RunPart2(input: Input) -> String
}

extension Runable
{
  func Derived() -> any Runable
  {
    return self
  }
}
