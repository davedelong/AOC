//
//  Day3.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day3: Day {
    
    static var rawInput: String? { nil }

    func part1() async throws -> Int {
        return input().lines.raw.map { line -> Int in
            let half = line.index(line.startIndex, offsetBy: line.count / 2)
            let firstHalf = Set(line[line.startIndex ..< half])
            let secondHalf = Set(line[half...])
            
            let intersection = firstHalf.intersection(secondHalf)
            
            let common = intersection.first!
            let priority = common.lowercased().first!.asciiValue! - "a".first!.asciiValue!
            
            return Int(priority + 1 + (common.isUppercase ? 26 : 0))
        }.sum
    }

    func part2() async throws -> Int {
        return input().lines.raw.chunks(of: 3).map { lines -> Int in
            let set = Set(lines.first!)
            let intersection = set.intersection(lines.second!).intersection(lines.last!)
            let common = intersection.first!
            let priority = common.lowercased().first!.asciiValue! - "a".first!.asciiValue!
            
            return Int(priority + 1 + (common.isUppercase ? 26 : 0))
        }.sum
    }

    func run() async throws -> (Int, Int) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

}
