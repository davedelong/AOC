//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

public class Day1: Day {
    
    public init() { super.init(inputSource: .file(#file)) }
    
    func checksum(_ ints: Array<Int>, offset: Int) -> String {
        let consecutivelyEqual = ints.enumerated().map { (index, element) -> Int in
            let pair = ints[(index + offset) % ints.count]
            return element == pair ? element : 0
        }
        
        let sum = consecutivelyEqual.sum()
        return "\(sum)"
    }
    
    override public func part1() -> String {
        return checksum(input.characters.integers, offset: 1)
    }
    
    override public func part2() -> String {
        let integers = input.characters.integers
        return checksum(integers, offset: integers.count / 2)
    }
    
}

}
