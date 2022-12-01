//
//  Day1.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day1: Day {
    
    static var rawInput: String? { nil }

    func run() async throws -> (Int, Int) {
        let lines = input().lines
        
        var elves = Array<Int>()
        var currentTotal = 0
        for line in lines {
            if line.raw.isEmpty {
                elves.append(currentTotal)
                currentTotal = 0
            } else {
                currentTotal += line.integer!
            }
        }
        
        if currentTotal > 0 { elves.append(currentTotal) }
        
        let sorted = elves.sorted(by: >)
        let p1 = sorted[0]
        let p2 = sorted[0] + sorted[1] + sorted[2]
        
        return (p1, p2)
    }

}
