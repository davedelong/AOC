//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day1: Day {
    
    init() { super.init(inputFile: #file) }
    
    override func part1() -> String {
        var floor = 0
        for char in input.characters {
            if char == "(" { floor += 1 }
            if char == ")" { floor -= 1 }
        }
        return "\(floor)"
    }
    
    override func part2() -> String {
        var floor = 0
        for (position, char) in input.characters.enumerated() {
            if char == "(" { floor += 1 }
            if char == ")" { floor -= 1 }
            if floor == -1 { return "\(position + 1)" }
        }
        fatalError("unreachable")
    }
    
}
