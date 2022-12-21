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
    
    enum Operation {
        case value(Int)
        case math(String, String, (Int, Int) -> Int)
    }
    
    struct Monkey {
        let name: String
        let operation: Operation
        
        func evaluate(using monkeys: Dictionary<String, Monkey>) -> Int {
            switch operation {
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
            
            let op: Operation
            if let int = line.integers.first {
                op = .value(int)
            } else if let m = r.firstMatch(in: remainder) {
                let a = m[1]!
                let b = m[3]!
                
                switch m[2] {
                    case "+": op = .math(a, b, +)
                    case "-": op = .math(a, b, -)
                    case "*": op = .math(a, b, *)
                    case "/": op = .math(a, b, /)
                    default: continue
                }
            } else {
                continue
            }
            
            monkeys[name] = Monkey(name: name, operation: op)
        }
        
        return monkeys
    }

    func part1() async throws -> Part1 {
        let monkeys = parseInput()
        let root = monkeys["root"]!
        return root.evaluate(using: monkeys)
    }
    
    func part2() async throws -> Part2 {
        let monkeysNamesAndExpressions = input().lines.raw.map { l -> (String, Expression) in
            let name = String(l.prefix(4))
            let remainder = l.dropFirst(6)
            
            if name == "humn" {
                return (name, try! Expression(string: "$humn"))
            } else {
                var e = try! Expression(string: String(remainder))
                if name == "root" {
                    /*
                     the instructions say that "root" should be an == comparison
                     however, by doing a subtraction instead, we can instead plot the function itself
                     and use that to converge on a correct evaluation. when it evaluates to 0,
                     we'll have found the right value for $humn
                     */
                    let args = e.kind.functionArguments!
                    e = Expression(kind: .function("subtract", args),
                                   range: e.range)
                }
                return (name, e)
            }
            
        }
        
        let monkeys = Dictionary(uniqueKeysWithValues: monkeysNamesAndExpressions)
        var root = monkeys["root"]!
        
        func resolve(_ expression: Expression) -> Expression {
            switch expression.kind {
                case .function(let name, let args):
                    if args.isEmpty {
                        let base = monkeys[name]!
                        return resolve(base)
                    } else {
                        let resolved = args.map { resolve($0) }
                        return Expression(kind: .function(name, resolved), range: expression.range)
                    }
                    
                case .number: return expression
                case .variable: return expression
            }
        }
        
        // this just hooks up all the functions into a single, evaluatable expression
        root = resolve(root)
        
        var range = 0 ... Int.max-1
        while range.count > 1 {
            let midPoint = range.lowerBound + (range.count / 2)
            let answer = try! Evaluator.default.evaluate(root, substitutions: ["humn": Double(midPoint)])
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
