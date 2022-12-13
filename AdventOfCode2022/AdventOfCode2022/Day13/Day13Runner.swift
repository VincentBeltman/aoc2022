//
//  Day13Runner.swift
//  AdventOfCode2022
//
//  Created by Inspiro developer on 30/11/2022.
//

import Foundation

class Day13Runner: Runable
{
  class Packet: CustomStringConvertible
  {
    weak var parent: Packet?
    var number: Int?
    var childs: [Packet] = []

    init(parent: Packet?)
    {
      self.parent = parent
    }

    var description: String { number != nil ? "\(number!)" : "[\(childs.map{ "\($0)" }.joined(separator: ","))]" }

    func isBefore(_ other: Packet) -> Bool?
    {
      for (i, myChild) in childs.enumerated()
      {
        if i == other.childs.count
        { return false }  // Left is bigger than right
        let otherChild: Packet = other.childs[i]
        if let myNumber: Int = myChild.number, let theirNumber: Int = otherChild.number // Both are numbers, so check
        {
          if myNumber > theirNumber
          { return false }
          if myNumber < theirNumber
          { return true }
        }
        else if myChild.number == nil, otherChild.number == nil // Both are arrays, go deeper
        {
          if let before: Bool = myChild.isBefore(otherChild)
          { return before }
        }
        else
        {
          let temp: Packet = Packet(parent: nil)
          if myChild.number == nil // Other child is a number, so make an array of my child
          {
            temp.childs.append(otherChild)
            if let before: Bool = myChild.isBefore(temp)
            { return before } // Order determined
          }
          else // My child is a number, so make an array of other child
          {
            temp.childs.append(myChild)
            if let before: Bool = temp.isBefore(otherChild)
            { return before } // Order determined
          }
        }
      }
      if childs.count < other.childs.count // Left is smaller than right
      { return true }
      return nil // Couldn't determine order
    }
  }
  func parsePacket(raw: Substring) -> Packet
  {
    var top: Packet?
    var currentPacket: Packet?
    var number: Int?

    func tryAddNumber()
    {
      if let numberNonNil = number
      {
        let newPacket: Packet = Packet(parent: currentPacket)
        newPacket.number = numberNonNil
        currentPacket?.childs.append(newPacket)
        number = nil
      }
    }

    for char in raw
    {
      if char == "["
      {
        let newPacket: Packet = Packet(parent: currentPacket)
        currentPacket?.childs.append(newPacket)
        currentPacket = newPacket
        if top == nil
        {
          top = currentPacket
        }
      }
      else if char == "]"
      {
        tryAddNumber()
        currentPacket = currentPacket?.parent
      }
      else if char == ","
      {
        tryAddNumber()
        continue
      }
      else
      {
        number = (number ?? 0) * 10 + Int(String(char))!
      }
    }
    return top!
  }

  func RunPart1(input: Input) -> String
  {
    let packetPairs: [[Substring]] = input.exploded(separators: ["\n\n", "\n"])
    var total: Int = 0
    for (i, packetPair) in packetPairs.enumerated()
    {
      let (left, right) = (parsePacket(raw: packetPair[0]), parsePacket(raw: packetPair[1]))
      assert("\(left)" == packetPair[0] && "\(right)" == packetPair[1])
      total += left.isBefore(right)! ? i+1 : 0
    }
    return "\(total)"
  }
  func RunPart2(input: Input) -> String
  {
    let packetPairs: [[Substring]] = input.exploded(separators: ["\n\n", "\n"])
    var packets: [Packet] = []
    for packetPair in packetPairs
    {
      packets.append(parsePacket(raw: packetPair[0]))
      packets.append(parsePacket(raw: packetPair[1]))
    }
    let dividerPacket2: Packet = parsePacket(raw: "[[2]]")
    var dividerIndex2: Int?
    let dividerPacket6: Packet = parsePacket(raw: "[[6]]")
    var dividerIndex6: Int?
    for (i, packet) in packets.sorted(by: { $0.isBefore($1)! }).enumerated()
    {
      if dividerIndex2 == nil && dividerPacket2.isBefore(packet)!
      { dividerIndex2 = i+1 }
      if dividerIndex6 == nil && dividerPacket6.isBefore(packet)!
      { dividerIndex6 = i+2 }
    }

    return "\(dividerIndex2! * dividerIndex6!)"
  }
}
