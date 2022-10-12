//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/8/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day9: Day {
    
    func part1() async throws -> String {
        let intcode = Intcode(memory: input().integers, input: 1)
        intcode.runUntilAfterNextOutput() // the first output is what we care about
        return "\(intcode.io!)"
    }
    
    func part2() async throws -> String {
        let intcode = Intcode(memory: input().integers, input: 2)
        intcode.runUntilAfterNextOutput() // the first output is what we care about
        return "\(intcode.io!)"
    }
    
}
