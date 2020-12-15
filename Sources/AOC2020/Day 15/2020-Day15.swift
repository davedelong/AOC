//
//  Day15.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day15: Day {
    
    override init() {
        super.init(rawInput: "8,11,0,19,1,2")
    }

    override func run() -> (String, String) {
        return super.run()
    }

    override func part1() -> String {
        return "\(run(times: 2020))"
    }

    override func part2() -> String {
        return "\(run(times: 30_000_000))"
    }
    
    private func run(times: Int) -> Int {
        typealias P = (Int, Int?)
        var turnForNumber = Dictionary<Int, P>(minimumCapacity: 100_000)
        var turn = 0
        
        var lastNumberSpoken = 0
        for int in input.integers {
            turn += 1
            turnForNumber[int] = P(turn, nil)
            lastNumberSpoken = int
        }
        
        while turn < times {
            turn += 1
            if let p = turnForNumber[lastNumberSpoken], let s = p.1 {
                lastNumberSpoken = p.0 - s
            } else {
                lastNumberSpoken = 0
            }
            let p2 = turnForNumber[lastNumberSpoken]?.0
            turnForNumber[lastNumberSpoken] = P(turn, p2)
        }
        return lastNumberSpoken
    }

}
