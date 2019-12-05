//
//  Day5.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day5: Day {
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    override func part1() -> String {
        let intcode = Intcode(memory: input.integers, supportedOperations: [.add, .multiply, .set, .get, .break])
        let answer = intcode.run(input: 1)
        return "\(answer)"
    }
    
    override func part2() -> String {
        let intcode = Intcode(memory: input.integers, supportedOperations: [.add, .multiply, .set, .get, .jumpIfTrue, .jumpIfFalse, .lessThan, .equal, .break])
        let answer = intcode.run(input: 5)
        return "\(answer)"
    }
    
}
