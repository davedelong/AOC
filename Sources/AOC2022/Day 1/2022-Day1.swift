//
//  Day1.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day1: Day {

    func run() async throws -> (Int, Int) {
        let elves = input().lines.split(on: \.isEmpty).map { $0.compactMap(\.integer).sum }
        
        let p1 = elves.max()!
        let p2 = elves.max(count: 3).sum
        return (p1, p2)
    }

}
