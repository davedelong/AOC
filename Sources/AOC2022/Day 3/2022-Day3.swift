//
//  Day3.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day3: Day {

    func part1() async throws -> Int {
        return input().lines.raw.map { line -> Int in
            let common = line.divide(into: 2).commonElements.first!
            return common.alphabeticOrdinal! + (common.isUppercase ? 26 : 0)
        }.sum
    }

    func part2() async throws -> Int {
        return input().lines.raw.chunks(ofCount: 3).map { lines -> Int in
            let common = lines.commonElements.first!
            return common.alphabeticOrdinal! + (common.isUppercase ? 26 : 0)
        }.sum
    }

}
