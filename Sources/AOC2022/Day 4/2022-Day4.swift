//
//  Day4.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day4: Day {
    
    static var rawInput: String? { nil }
    
    let r = Regex(#"(\d+)-(\d+),(\d+)-(\d+)"#)
    
    func part1() async throws -> Int {
        return input().lines.raw.filter { line in
            guard let m = r.firstMatch(in: line) else { return false }
            
            let r1 = m[int: 1]! ... m[int: 2]!
            let r2 = m[int: 3]! ... m[int: 4]!
            
            return (r1.lowerBound <= r2.lowerBound && r1.upperBound >= r2.upperBound) || (r2.lowerBound <= r1.lowerBound && r2.upperBound >= r1.upperBound)
        }.count
    }
    
    func part2() async throws -> Int {
        return input().lines.raw.filter { line in
            guard let m = r.firstMatch(in: line) else { return false }
            
            let r1 = m[int: 1]! ... m[int: 2]!
            let r2 = m[int: 3]! ... m[int: 4]!
            
            return Set(r1).intersects(Set(r2))
        }.count
    }

    func run() async throws -> (Int, Int) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

}
