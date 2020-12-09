//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

import Algorithms

class Day1: Day {

    override func part1() -> String {
        let integers = input.integers
        let combos = integers.combinations(choose: 2)
        let pair = combos.first(where: { $0.sum == 2020 })!
        return "\(pair.product)"
    }

    override func part2() -> String {
        let integers = input.integers
        let combos = integers.combinations(choose: 3)
        let pair = combos.first(where: { $0.sum == 2020 })!
        return "\(pair.product)"
    }

}
