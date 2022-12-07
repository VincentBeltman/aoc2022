//
//  RunFactory.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

let day: Int = 7

func CreateRunner() -> any Runable
{
  print("Running advent of code for day \(day)")
  switch(day)
  {
  case 1:
    return Day1Runner()
  case 2:
    return Day2Runner()
  case 3:
    return Day3Runner()
  case 4:
    return Day4Runner()
  case 5:
    return Day5Runner()
  case 6:
    return Day6Runner()
  case 7:
    return Day7Runner()
  case 8:
    return Day8Runner()
  case 9:
    return Day9Runner()
  case 10:
    return Day10Runner()
  case 11:
    return Day11Runner()
  case 12:
    return Day12Runner()
  case 13:
    return Day13Runner()
  case 14:
    return Day14Runner()
  case 15:
    return Day15Runner()
  case 16:
    return Day16Runner()
  case 17:
    return Day17Runner()
  case 18:
    return Day18Runner()
  case 19:
    return Day19Runner()
  case 20:
    return Day20Runner()
  case 21:
    return Day21Runner()
  case 22:
    return Day22Runner()
  case 23:
    return Day23Runner()
  case 24:
    return Day24Runner()
  case 25:
    return Day25Runner()
  default:
    fatalError("No valid day selected")
  }
}
