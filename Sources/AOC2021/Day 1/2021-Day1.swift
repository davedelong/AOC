//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import Algorithms

class Day1: Day {

    override func part1() -> String {
        let increases = input.lines.integers
            .adjacentPairs()
            .count { $1 > $0 }
        
        return "\(increases)"
    }

    override func part2() -> String {
        let increases = input.lines.integers
            .windows(ofCount: 3)
            .map(\.sum)
            .adjacentPairs()
            .count { $1 > $0 }
        
        return "\(increases)"
    }

}
