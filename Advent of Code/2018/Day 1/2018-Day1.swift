//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2018 {

    class Day1: Day {
        
        init() { super.init() }
        
        override func part1() -> String {
            let sum = trimmedInputLineIntegers.reduce(0, +)
            return "\(sum)"
        }
        
        override func part2() -> String {
            var frequency = 0
            var seen = Set([frequency])
            var index = 0
            while true {
                frequency += trimmedInputLineIntegers[index]
                if seen.contains(frequency) { return "\(frequency)" }
                index = (index + 1) % trimmedInputLineIntegers.count
                seen.insert(frequency)
            }
            fatalError("unreachable")
        }
        
    }

}
