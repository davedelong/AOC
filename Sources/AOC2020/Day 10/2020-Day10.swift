//
//  Day10.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day10: Day {
    
    override func run() -> (String, String) {
        let adapters = input.lines.integers.sorted()
        let diffs = adapters.reversed().consecutivePairs().map(-)
        let p1 = (diffs.count(of: 1) + 1) * (diffs.count(of: 3) + 1)
        
        var memo = [0:1]
        for target in adapters {
            memo[target] = (1...3).sum { memo[target - $0] ?? 0 }
        }
        let p2 = memo[adapters.last!]!
        
        return ("\(p1)", "\(p2)")
    }
}
