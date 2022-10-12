//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/20/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day21: Day {
    
    func part1() async throws -> String {
        let i = Intcode(memory: input().integers)
        
        // if (A == false || B == false || c == false) && D == true { jump }
        // else walk
        var input = """
NOT A J
NOT B T
OR T J
NOT C T
OR T J
NOT D T
NOT T T
AND T J
WALK

"""[...]
        i.input = { input.popFirst()?.asciiValue.map { Int($0) } }
        i.runWithHandlers()
        return "\(i.io!)"
    }
    
    func part2() async throws -> String {
        let i = Intcode(memory: input().integers)
        
        // if (A == false || B == false || c == false) && D == true { jump }
        // else run
        var input = """
NOT A J
NOT B T
OR T J
NOT C T
OR T J
OR A T
AND B T
AND C T
AND D T
NOT T T
AND T J
AND E T
OR H T
AND T J
AND D J
RUN

"""[...]
        i.input = { input.popFirst()?.asciiValue.map { Int($0) } }
        i.runWithHandlers()
        return "\(i.io!)"
    }
    
}
