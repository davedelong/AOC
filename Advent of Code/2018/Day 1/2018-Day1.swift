//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2018 {

    class Day1: Day {
        
        let input = Day1.inputIntegers()
        
        required init() { }
        
        func part1() -> String {
            let sum = input.reduce(0, +)
            return "\(sum)"
        }
        
        func part2() -> String {
            var frequency = 0
            var seen = Set([frequency])
            var index = 0
            while true {
                frequency += input[index]
                if seen.contains(frequency) { return "\(frequency)" }
                index = (index + 1) % input.count
                seen.insert(frequency)
            }
            fatalError("unreachable")
        }
        
    }

}
