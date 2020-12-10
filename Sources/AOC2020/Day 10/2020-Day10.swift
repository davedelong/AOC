//
//  Day10.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day10: Day {
    
    override func part1() -> String {
        let adapters = input.lines.integers.sorted()
        let diffs = adapters.reversed().consecutivePairs().map(-)
        let answer = (diffs.count(of: 1) + 1) * (diffs.count(of: 3) + 1)
        return "\(answer)"
    }

    override func part2() -> String {
        let adapters = [0] + input.lines.integers.sorted()
        var memo = [0:1]
        
        for target in adapters {
            let possible = adapters.filter { $0 >= (target-3) && $0 < target }
            let counts = possible.map { memo[$0, default: 1] }
            if target > 0 { memo[target] = counts.sum }
        }
        let total = memo[adapters.last!]!
        return "\(total)"
    }
}
