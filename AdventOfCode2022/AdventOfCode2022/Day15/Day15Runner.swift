//
//  Day15Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day15Runner: Runable
{
  struct Sensor
  {
    let x: Int
    let y: Int
    let manhattan: Int
  }
  func RunPart1(input: Input) -> String
  {
    let lines: [[[Substring]]] = input.exploded(separators: ["\n", " ", "="])
    var sensors: [Sensor] = []
    for line in lines
    {
      let (sensorX, sensorY, beaconX, beaconY) = (Int(line[2][1])!, Int(line[3][1])!, Int(line[8][1])!, Int(line[9][1])!)
      sensors.append(Sensor(
        x: sensorX,
        y: sensorY,
        manhattan: abs(sensorX-beaconX) + abs(sensorY-beaconY)))
    }
    sensors = sensors.sorted(by: { $0.x < $1.x })
    let checkY: Int = 2000000
    var total: Int = 0
    var lastX: Int = sensors[0].x-sensors[0].manhattan
    for sensor in sensors
    {
      let diffY: Int = abs(checkY - sensor.y)
      if diffY <= sensor.manhattan
      {
        let minX = max(sensor.x - (sensor.manhattan-diffY), lastX)
        let maxX = sensor.x + (sensor.manhattan-diffY)
        if maxX > minX
        {
          total += maxX-minX
          lastX = maxX
        }
      }
    }
    return "\(total)"
  }

  func RunPart2(input: Input) -> String
  {
    let lines: [[[Substring]]] = input.exploded(separators: ["\n", " ", "="])
    var sensors: [Sensor] = []
    for line in lines
    {
      let (sensorX, sensorY, beaconX, beaconY) = (Int(line[2][1])!, Int(line[3][1])!, Int(line[8][1])!, Int(line[9][1])!)
      sensors.append(Sensor(
        x: sensorX,
        y: sensorY,
        manhattan: abs(sensorX-beaconX) + abs(sensorY-beaconY)))
    }
    sensors = sensors.sorted(by: { $0.x < $1.x })
    for checkY in 0...4000000
    {
      print(checkY)
      var ranges: [(Int, Int)] = []
      for sensor in sensors
      {
        let diffY: Int = abs(checkY - sensor.y)
        if diffY <= sensor.manhattan
        {
          ranges.append((sensor.x - (sensor.manhattan-diffY), sensor.x + (sensor.manhattan-diffY)))
        }
      }
      ranges = ranges.sorted(by: {$0.0 < $1.0})
      var lastX: Int = ranges[0].0
      for range in ranges
      {
        if lastX < range.0
        {
          return "\((lastX+1)*4000000 + checkY)"
        }
        lastX = max(lastX,range.1)
      }
    }
    return "Not found :("
  }
}
