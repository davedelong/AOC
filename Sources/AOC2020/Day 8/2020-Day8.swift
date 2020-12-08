//
//  Day8.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day8: Day {
    
    enum Instruction: Equatable {
        case jmp(Int)
        case acc(Int)
        case nop(Int)
        
        var isAcc: Bool {
            if case .acc = self { return true }
            return false
        }
    }
    
    private lazy var instructions: Array<Instruction> = {
        let r: Regex = #"(jmp|acc|nop) ([-+]?\d+)"#
        return input.rawLines.map { line -> Instruction in
            let match = r.match(line)!
            switch match[1]! {
                case "jmp": return .jmp(match[int: 2]!)
                case "acc": return .acc(match[int: 2]!)
                default: return .nop(match[int: 2]!)
            }
        }
    }()

    override func part1() -> String {
        let (ans, _) = run(instructions)
        return "\(ans)"
    }

    override func part2() -> String {
        var nextIndex = 0
        var p2 = 0
        while nextIndex < instructions.count {
            let slice = instructions[nextIndex...]
            if let next = slice.firstIndex(where: { !$0.isAcc }) {
                var copy = instructions
                if case .jmp(let n) = copy[next] {
                    copy[next] = .nop(n)
                } else if case .nop(let n) = copy[next] {
                    copy[next] = .jmp(n)
                } else { fatalError() }
                
                let (ans, looped) = run(copy)
                if looped == false {
                    p2 = ans
                    break
                }
                
                nextIndex = next+1
                
            }
        }
        return "\(p2)"
    }
    
    private func run(_ instructions: Array<Instruction>) -> (Int, Bool) {
        var ptr = 0
        var acc = 0
        var visited = Set<Int>()
        var looped = false
        
        while ptr < instructions.count {
            if visited.contains(ptr) {
                looped = true
                break
            }
            visited.insert(ptr)
            switch instructions[ptr] {
                case .jmp(let off): ptr += off; continue
                case .acc(let diff): acc += diff
                case .nop: break
            }
            ptr += 1
        }
        return (acc, looped)
    }

}
