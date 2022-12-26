//
//  LCM.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 22/12/2022.
//

import Foundation

func gcd(_ x: Int, _ y: Int) -> Int
{
  var a = 0; var b = max(x, y); var c = min(x, y)
  while c != 0 { a = b; b = c; c = a % b }
  return b
}

func lcm(_ x: Int, _ y: Int) -> Int
{
  return x / gcd(x, y) * y
}
