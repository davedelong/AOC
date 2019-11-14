//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

extension Year2015 {

    public class Day1: Day {
        
        public init() { super.init(inputFile: #file) }
        
        override public func part1() -> String {
            var floor = 0
            for char in input.characters {
                if char == "(" { floor += 1 }
                if char == ")" { floor -= 1 }
            }
            return "\(floor)"
        }
        
        override public func part2() -> String {
            var floor = 0
            for (position, char) in input.characters.enumerated() {
                if char == "(" { floor += 1 }
                if char == ")" { floor -= 1 }
                if floor == -1 { return "\(position + 1)" }
            }
            fatalError("unreachable")
        }
        
    }

}
