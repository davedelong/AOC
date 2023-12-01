//
//  Day4.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day4: Day {
    
    let r = /(\d+)-(\d+),(\d+)-(\d+)/
    
    func part1() async throws -> Int {
        return input().lines.raw.filter { line in
            guard let m = r.firstMatch(in: line) else { return false }
            
            let r1 = m[int: 1]! ... m[int: 2]!
            let r2 = m[int: 3]! ... m[int: 4]!
            
            return r1.fullyContains(r2) || r2.fullyContains(r1)
        }.count
    }
    
    func part2() async throws -> Int {
        return input().lines.raw.filter { line in
            guard let m = r.firstMatch(in: line) else { return false }
            
            let r1 = m[int: 1]! ... m[int: 2]!
            let r2 = m[int: 3]! ... m[int: 4]!
            let r = r1.relation(to: r2)
            return !r.isDisjoint
        }.count
    }

}
