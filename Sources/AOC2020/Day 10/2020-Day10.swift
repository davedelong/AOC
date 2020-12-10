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
        var _1diff = 1
        var _3diff = 1
        
        for (p, t) in adapters.consecutivePairs() {
            if t - p == 1 { _1diff += 1 }
            if t - p == 3 { _3diff += 1 }
        }
        
        return "\(_1diff * _3diff)"
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
