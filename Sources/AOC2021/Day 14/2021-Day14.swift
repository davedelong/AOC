//
//  Day14.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day14: Day {

    let r: Regex = #"(..) -> (.)"#
    lazy var rules: Dictionary<String, String> = {
        let pairs = input.rawLines.compactMap { l -> (String, String)? in
            guard let m = r.firstMatch(in: l) else { return nil }
            return (m[1]!, m[2]!)
        }
        return Dictionary(uniqueKeysWithValues: pairs)
    }()
    
    lazy var source: String = { input.rawLines[0] }()

    override func part1() -> String {
        return "\(runInput(times: 10))"
    }

    override func part2() -> String {
        return "\(runInput(times: 40))"
    }
    
    private func runInput(times: Int) -> Int {
        var counts = CountedSet<String>()
        for (f, c) in source.consecutivePairs() {
            counts["\(f)\(c)", default: 0] += 1
        }
        
        for _ in 0 ..< times {
            counts = applyRules(to: counts)
        }
        
        var finalCounts = CountedSet<Character>()
        for (str, count) in counts {
            for char in str {
                finalCounts[char, default: 0] += count
            }
        }
        // everything's been double-counted except the first and last characters
        finalCounts[source.first!, default: 0] += 1
        finalCounts[source.last!, default: 0] += 1
        
        let max = finalCounts.mostCommon()!
        let min = finalCounts.leastCommon()!
        
        // "un" double-count the values
        let maxCount = finalCounts.count(for: max) / 2
        let minCount = finalCounts.count(for: min) / 2
        
        return maxCount - minCount
    }
    
    private func applyRules(to input: CountedSet<String>) -> CountedSet<String> {
        var newCounts = CountedSet<String>()
        for (key, count) in input {
            let rule = rules[key]!
            
            let p1 = "\(key.first!)\(rule)"
            let p2 = "\(rule)\(key.last!)"
            newCounts[p1, default: 0] += count
            newCounts[p2, default: 0] += count
        }
        return newCounts
    }

}
