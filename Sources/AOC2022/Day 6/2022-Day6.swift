//
//  Day6.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day6: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }

    func part1() async throws -> Part1 {
        let chunk = input().characters.windows(ofCount: 4).first(where: \.allUnique)!
        return chunk.startIndex + chunk.count
    }

    func part2() async throws -> Part2 {
        let chunk = input().characters.windows(ofCount: 14).first(where: \.allUnique)!
        return chunk.startIndex + chunk.count
    }

}
