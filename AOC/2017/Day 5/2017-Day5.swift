//
//  Day5.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

public class Day5: Day {
    
    public init() { super.init(inputSource: .file(#file)) }
    
    override public func part1() -> String {
        var integers = input.trimmed.lines.integers
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
    
    override public func part2() -> String {
        var integers = input.trimmed.lines.integers
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

}
