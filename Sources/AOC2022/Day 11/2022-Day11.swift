//
//  Day11.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day11: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    struct Monkey: CustomStringConvertible {
        let id: Int
        var items = Array<Int>()
        var operation: (Int) -> Int
        var test: Int
        var trueTarget: Int
        var falseTarget: Int
        
        var description: String {
            return "Monkey \(id): \(items)"
        }
    }
    
    private func parseMonkeys() -> Array<Monkey> {
        return input().lines.split(on: \.isEmpty).map { lineChunk in
            let id = lineChunk[offset: 0].integers[0]
            let items = lineChunk[offset: 1].integers
            let operand = lineChunk[offset: 2].integers.first
            let operation = lineChunk[offset: 2].raw.first(where: { $0 == "*" || $0 == "+" || $0 == "/" || $0 == "-" })!
            
            let test = lineChunk[offset: 3].integers[0]
            let trueTarget = lineChunk[offset: 4].integers[0]
            let falseTarget = lineChunk[offset: 5].integers[0]
            
            return Monkey(id: id,
                          items: items,
                          operation: {
                            let op = operand ?? $0
                            switch operation {
                                case "*": return $0 * op
                                case "+": return $0 + op
                                case "/": return $0 / op
                                case "-": return $0 - op
                                default: fatalError()
                            }
                          },
                          test: test,
                          trueTarget: trueTarget,
                          falseTarget: falseTarget)
        }
    }

    func part1() async throws -> Part1 {
        var monkeys = parseMonkeys()
        var monkeyCount = Array(repeating: 0, count: monkeys.count)
        
        for _ in 1 ... 20 {
            for i in monkeys.indices {
                monkeyCount[i] += monkeys[i].items.count
                
                for item in monkeys[i].items {
                    let worryLevel = monkeys[i].operation(item)
                    let boredLevel = worryLevel / 3
                    if boredLevel.isMultiple(of: monkeys[i].test) {
                        monkeys[monkeys[i].trueTarget].items.append(boredLevel)
                    } else {
                        monkeys[monkeys[i].falseTarget].items.append(boredLevel)
                    }
                }
                
                monkeys[i].items.removeAll()
            }
        }
        
        let sorted = monkeyCount.sorted(by: >)
        return sorted[0] * sorted[1]
    }

    func part2() async throws -> Part2 {
        var monkeys = parseMonkeys()
        let divisor = monkeys.product(of: \.test)
        
        var monkeyCount = Array(repeating: 0, count: monkeys.count)
        
        for _ in 1 ... 10_000 {
            for i in monkeys.indices {
                monkeyCount[i] += monkeys[i].items.count
                
                for item in monkeys[i].items {
                    let worryLevel = monkeys[i].operation(item) % divisor
                    if worryLevel.isMultiple(of: monkeys[i].test) {
                        monkeys[monkeys[i].trueTarget].items.append(worryLevel)
                    } else {
                        monkeys[monkeys[i].falseTarget].items.append(worryLevel)
                    }
                }
                
                monkeys[i].items.removeAll()
            }
        }
        
        let sorted = monkeyCount.sorted(by: >)
        return sorted[0] * sorted[1]
    }

}
