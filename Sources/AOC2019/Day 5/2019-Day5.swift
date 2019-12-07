//
//  Day5.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day5: Day {
    
    override func part1() -> String {
        let intcode = Intcode(memory: input.integers, input: 1)
        return "\(intcode.run())"
    }
    
    override func part2() -> String {
        let intcode = Intcode(memory: input.integers, input: 5)
        return "\(intcode.run())"
    }
    
}
