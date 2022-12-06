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
        for w in input().characters.windows(ofCount: 4) {
            if Set(w).count == 4 {
                return w.startIndex + w.count
            }
        }
        
        fatalError()
    }

    func part2() async throws -> Part2 {
        for w in input().characters.windows(ofCount: 14) {
            if Set(w).count == 14 {
                return w.startIndex + w.count
            }
        }
        
        fatalError()
    }

}
