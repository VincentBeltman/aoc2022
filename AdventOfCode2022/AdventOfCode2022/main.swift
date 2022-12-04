//
//  main.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation
let runner = CreateRunner()

let input1 = Input(input: Input1.input)
let start1 = DispatchTime.now()
print("Part 1:", runner.RunPart1(input: input1))
let end1 = DispatchTime.now()
print("Finished in \(Double(end1.uptimeNanoseconds-start1.uptimeNanoseconds)/1_000_000_000) secs")

let input2 = Input(input: Input2.input)
let start2 = DispatchTime.now()
print("Part 2:", runner.RunPart2(input: input2))
let end2 = DispatchTime.now()
print("Finished in \(Double(end2.uptimeNanoseconds-start2.uptimeNanoseconds)/1_000_000_000) secs")

//let derived: Day1Runner = runner.Derived() as! Day1Runner
//derived.test()
