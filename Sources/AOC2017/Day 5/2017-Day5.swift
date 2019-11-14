//
//  Day5.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day5: Day {
    
    @objc init() { super.init(inputFile: #file) }
    
    override func part1() -> String {
        var integers = input.lines.integers
        var stepCount = 0
        var index = 0
        while index < integers.count {
            let offset = integers[index]
            integers[index] = offset + 1
            index += offset
            stepCount += 1
        }
        return "\(stepCount)"
    }
    
    override func part2() -> String {
        var integers = input.lines.integers
        var stepCount = 0
        var index = 0
        while index < integers.count {
            let offset = integers[index]
            
            let delta = (offset >= 3) ? -1 : 1
            integers[index] = offset + delta
            index += offset
            stepCount += 1
        }
        return "\(stepCount)"
    }
}
