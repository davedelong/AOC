//
//  Day2.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day2: Day {
    
    private func intcode(noun: Int, verb: Int) -> Int {
        var memory = input.lines[0].integers
        memory[1] = noun
        memory[2] = verb
        
        var current = 0
        repeat {
            let op = memory[current]
            if op == 99 { break }
            let p1 = memory[current+1]
            let p2 = memory[current+2]
            let p3 = memory[current+3]
            if op == 1 {
                memory[p3] = memory[p1] + memory[p2]
            } else if op == 2 {
                memory[p3] = memory[p1] * memory[p2]
            }
            current += 4
        } while current < memory.count
        
        return memory[0]
    }
    
    override func part1() -> String {
        let answer = intcode(noun: 12, verb: 2)
        return "\(answer)"
    }
    
    override func part2() -> String {
        for noun in 0 ..< 100 {
            for verb in 0 ..< 100 {
                let answer = intcode(noun: noun, verb: verb)
                if answer == 19690720 { return "\((100*noun) + verb)" }
            }
        }
        fatalError()
    }
    
}
