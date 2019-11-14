//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/5/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

import Foundation

class Day7: Day {
    
    typealias Registers = Dictionary<String, UInt16>
    typealias Command = (Registers) -> Registers
    
    init() { super.init(inputFile: #file) }
    
    lazy var commands: Array<Command> = {
        let r = Regex(pattern: "(NOT (.+?)|(\\d+)|(.+?) (AND|OR|LSHIFT|RSHIFT) (.+?)|(.+?)) -> (.+)")
        return input.lines.raw.map { l -> Command in
            let m = r.match(l)!
            let dst = m[8]!
            
            if let notRegister = m[2] {
                return {
                    guard let value = $0[notRegister] else { return $0 }
                    var copy = $0
                    copy[dst] = ~value
                    return copy
                }
            } else if let value = m[3] {
                return {
                    var copy = $0
                    copy[dst] = UInt16(value)!
                    return copy
                }
            } else if let reg = m[7] {
                return {
                    guard let value = $0[reg] else { return $0 }
                    var copy = $0
                    copy[dst] = value
                    return copy
                }
            } else {
                let lhs = m[4]!
                let action = m[5]!
                let rhs = m[6]!
                return {
                    var copy = $0
                    guard let lValue = copy[lhs] ?? UInt16(lhs) else { return $0 }
                    guard let rValue = copy[rhs] ?? UInt16(rhs) else { return $0 }
                    if action == "AND" {
                        copy[dst] = lValue & rValue
                    } else if action == "OR" {
                        copy[dst] = lValue | rValue
                    } else if action == "LSHIFT" {
                        copy[dst] = lValue << rValue
                    } else if action == "RSHIFT" {
                        copy[dst] = lValue >> rValue
                    }
                    return copy
                }
            }
            
        }
    }()
    
    override func part1() -> String {
        var registers = Registers()
        var index = 0
        while registers["a"] == nil {
            let cmd = commands[index]
            registers = cmd(registers)
            index = (index + 1) % commands.count
        }
        let value = registers["a"] ?? 0
        return "\(value)"
    }
    
    override func part2() -> String {
        var registers = Registers()
        var index = 0
        while registers["a"] == nil {
            let cmd = commands[index]
            registers = cmd(registers)
            index = (index + 1) % commands.count
            registers["b"] = 956 // override wire b to always be this value
        }
        let value = registers["a"] ?? 0
        return "\(value)"
    }
    
}
