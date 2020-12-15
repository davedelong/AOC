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
        var turnForNumber = Dictionary<Int, Pair<Int>>()
        var turn = 0
        
        var lastNumberSpoken = 0
        for int in input.integers {
            turn += 1
            turnForNumber[int] = Pair(turn, -1)
            lastNumberSpoken = int
        }
        
        while turn < times {
            turn += 1
            let p = turnForNumber[lastNumberSpoken] ?? Pair(-1, -1)
            if p.first >= 0 && p.second >= 0 {
                lastNumberSpoken = p.first - p.second
            } else {
                lastNumberSpoken = 0
            }
            let p2 = turnForNumber[lastNumberSpoken] ?? Pair(-1, -1)
            turnForNumber[lastNumberSpoken] = Pair(turn, p2.first)
        }
        return lastNumberSpoken
    }

}
