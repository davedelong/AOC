//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

import Algorithms

class Day1: Day {

    func part1() async throws -> String {
        let integers = input().integers
        let combos = integers.combinations(choose: 2)
        let pair = combos.first(where: { $0.sum == 2020 })!
        return "\(pair.product)"
    }

    func part2() async throws -> String {
        let integers = input().integers
        let combos = integers.combinations(choose: 3)
        let pair = combos.first(where: { $0.sum == 2020 })!
        return "\(pair.product)"
    }

}
