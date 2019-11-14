//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/18/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day20: Day {
    
    @objc override init() { super.init(rawInput: "34000000") }
    
    override func part1() -> String {
        let target = input.integer!
        var scores = Dictionary<Int, Int>()
        for elfNumber in 1 ..< (target/10) {
            let houses = stride(from: elfNumber, to: target/10, by: elfNumber)
            for house in houses {
                scores[house, default: 0] += elfNumber * 10
            }
        }
        let matchingHouses = scores.filter { $0.value >= target }.map { $0.key }
        let house = matchingHouses.min()!
        return "\(house)"
    }
    
    override func part2() -> String {
        let target = input.integer!
        var scores = Dictionary<Int, Int>()
        for elfNumber in 1 ..< (target/11) {
            let houses = stride(from: elfNumber, to: target/11, by: elfNumber)
            var visitCount = 0
            for house in houses {
                scores[house, default: 0] += elfNumber * 11
                visitCount += 1
                if visitCount == 50 { break }
            }
        }
        let matchingHouses = scores.filter { $0.value >= target }.map { $0.key }
        let house = matchingHouses.min()!
        return "\(house)"
    }

}
