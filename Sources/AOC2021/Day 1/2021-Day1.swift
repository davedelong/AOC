//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import Algorithms

class Day1: Day {

    func part1() async throws -> Int {
        let increases = input().lines.integers
            .adjacentPairs()
            .count { $1 > $0 }
        
        return increases
    }

    func part2() async throws -> Int {
        let increases = input().lines.integers
            .windows(ofCount: 3)
            .map(\.sum.unwrapped)
            .adjacentPairs()
            .count { $1 > $0 }
        
        return increases
    }

}
