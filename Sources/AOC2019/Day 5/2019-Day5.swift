//
//  Day5.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day5: Day {
    
    func part1() async throws -> String {
        let intcode = Intcode(memory: input().integers, input: 1)
        return "\(intcode.run())"
    }
    
    func part2() async throws -> String {
        let intcode = Intcode(memory: input().integers, input: 5)
        return "\(intcode.run())"
    }
    
}
