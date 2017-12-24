//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/7/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

class Day8: Day {

    typealias Registers = Dictionary<String, Int>
    
    required init() { }

    func match(_ registers: Registers, _ register: String, _ op: String, _ value: String) -> Bool {
        let current = registers[register] ?? 0
        let val = Int(value)!
        switch op {
            case "<": return current < val
            case ">": return current > val
            case "<=": return current <= val
            case ">=": return current >= val
            case "!=": return current != val
            default: return current == val
        }
    }

    func run() -> (String, String) {
        let lines = Day8.inputLines()
        var registers = Registers()
        var intermediateMax = Int.min

        lines.forEach { line in
            let bits = line.components(separatedBy: " ")
            // j inc -19 if jhb >= 10
            if match(registers, bits[4], bits[5], bits[6]) {
                let multiplier = bits[1] == "dec" ? -1 : 1
                let delta = Int(bits[2])! * multiplier
                registers[bits[0]] = (registers[bits[0]] ?? 0) + delta
            }
            intermediateMax = max(intermediateMax, registers[bits[0]] ?? 0)
        }

        return ("\(registers.values.max()!)", "\(intermediateMax)")
    }

}
