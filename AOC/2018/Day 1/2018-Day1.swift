//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2018 {

    public class Day1: Day {
        
        public init() { super.init(inputSource: .file(#file)) }
        
        override public func part1() -> String {
            let sum = input.trimmed.lines.integers.reduce(0, +)
            return "\(sum)"
        }
        
        override public func part2() -> String {
            let integers = input.trimmed.lines.integers
            
            var frequency = 0
            var seen = Set([frequency])
            var index = 0
            while true {
                frequency += integers[index]
                if seen.contains(frequency) { return "\(frequency)" }
                index = (index + 1) % integers.count
                seen.insert(frequency)
            }
            fatalError("unreachable")
        }
        
    }

}
