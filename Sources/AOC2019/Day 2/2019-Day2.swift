//
//  Day2.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day2: Day {
    
    private func intcode(noun: Int, verb: Int) -> Int {
        var memory = input.integers
        memory[1] = noun
        memory[2] = verb
        let code = Intcode(memory: memory, supportedOperations: [.add, .multiply, .break])
        code.run()
        return code.memory[0]
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
