//
//  Day7.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//


class Day7: Day {

    override func part1() -> String {
        let positions = input.integers
        let range = positions.range()
        
        func cost(to position: Int) -> Int {
            return positions.sum { abs($0 - position) }
        }
        
        let least = range.lazy.map(cost(to:)).min()!
        return "\(least)"
    }

    override func part2() -> String {
        let positions = input.integers
        let range = positions.range()
        
        func cost(to position: Int) -> Int {
            return positions.sum { triangular(abs($0 - position)) }
        }
        
        let least = range.lazy.map(cost(to:)).min()!
        return "\(least)"
    }

}
