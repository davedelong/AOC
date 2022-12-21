//
//  Day21.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day21: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    enum Monkey {
        // normally this should be an `Int`,
        // but part 2 overflows an Int while binary searching for the answer,
        // and also converges incorrectly due to rounding
        case value(Double)
        case math(String, String, (Double, Double) -> Double)
        
        func evaluate(using monkeys: Dictionary<String, Monkey>) -> Double {
            switch self {
                case .value(let i):
                    return i
                case .math(let a, let b, let op):
                    let l = monkeys[a]!.evaluate(using: monkeys)
                    let r = monkeys[b]!.evaluate(using: monkeys)
                    return op(l, r)
            }
        }
    }
    
    func parseInput() -> Dictionary<String, Monkey> {
        var monkeys = Dictionary<String, Monkey>()
        
        let r = Regex(#"^(.+) ([\+\-\*\/]) (.+)$"#)
        
        for line in input().lines {
            let name = String(line.raw.prefix(4))
            let remainder = line.raw.dropFirst(6)
            
            let monkey: Monkey
            if let int = line.integers.first {
                monkey = .value(Double(int))
            } else if let m = r.firstMatch(in: remainder) {
                let a = m[1]!
                let b = m[3]!
                
                switch m[2] {
                    case "+": monkey = .math(a, b, +)
                    case "-": monkey = .math(a, b, -)
                    case "*": monkey = .math(a, b, *)
                    case "/": monkey = .math(a, b, /)
                    default: continue
                }
            } else {
                continue
            }
            
            monkeys[name] = monkey
        }
        
        return monkeys
    }

    func part1() async throws -> Part1 {
        let monkeys = parseInput()
        let root = monkeys["root"]!
        return Int(root.evaluate(using: monkeys))
    }
    
    func part2() async throws -> Part2 {
        var monkeys = parseInput()
        var root = monkeys["root"]!
        if case .math(let a, let b, _) = root {
            /*
             the instructions say that "root" should be an == comparison
             however, by doing a subtraction instead, we can instead plot the function itself
             and use that to converge on a correct evaluation. when it evaluates to 0,
             we'll have found the right value for $humn
             */
            root = .math(a, b, -)
        }
        
        var range = 0 ... Int.max-1
        while range.count > 1 {
            let midPoint = range.lowerBound + (range.count / 2)
            monkeys["humn"] = .value(Double(midPoint))
            let answer = root.evaluate(using: monkeys)
            print(midPoint, answer)
            if answer > 0 {
                // number is too low
                range = midPoint ... range.upperBound
            } else if answer < 0 {
                // number is too high
                range = range.lowerBound ... midPoint
            } else {
                // number is just right
                range = midPoint ... midPoint
            }
        }
        
        return range.lowerBound
    }

}
