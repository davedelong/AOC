//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

class Day1: Day {
    
    init() { super.init() }
    
    func checksum(_ ints: Array<Int>, offset: Int) -> String {
        let consecutivelyEqual = ints.enumerated().map { (index, element) -> Int in
            let pair = ints[(index + offset) % ints.count]
            return element == pair ? element : 0
        }
        
        let sum = consecutivelyEqual.reduce(0, +)
        return "\(sum)"
    }
    
    override func part1() -> String {
        return checksum(rawInputIntegers, offset: 1)
    }
    
    override func part2() -> String {
        return checksum(rawInputIntegers, offset: rawInputIntegers.count / 2)
    }
    
}

}
