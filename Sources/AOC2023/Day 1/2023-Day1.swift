//
//  Day1.swift
//  AOC2023
//
//  Created by Dave DeLong on 11/30/23.
//  Copyright © 2023 Dave DeLong. All rights reserved.
//

struct Day1: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }

    func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

    func part1() async throws -> Part1 {
        return input().lines.map { line in
            let numbers = line.characters.filter(\.isASCIIDigit)
            guard let f = numbers.first, let l = numbers.last else { return 0 }
            let num  = "\(f)\(l)"
            return Int(num)!
        }.sum!
    }

    func part2() async throws -> Part2 {
        let digit = /(one|two|three|four|five|six|seven|eight|nine)/
        let replace = [
            "one": "1",
            "two": "2",
            "three": "3",
            "four": "4",
            "five": "5",
            "six": "6",
            "seven": "7",
            "eight": "8",
            "nine": "9",
        ]
        
        return input().lines.map { line in
            var raw = line.raw
            
            let firstDigit = raw.firstIndex(where: \.isASCIIDigit)
            
            if let m = try? digit.firstMatch(in: raw) {
                if firstDigit == nil || m.range.lowerBound < firstDigit! {
                    let new = replace[String(m.1)]!
                    raw.replaceSubrange(m.range, with: new)
                }
            }
            
            let lastDigit = raw.lastIndex(where: \.isASCIIDigit)
            
            if let m = try? digit.lastMatch(in: raw) {
                if lastDigit == nil || m.1.startIndex > lastDigit! {
                    let new = replace[String(m.1)]!
                    raw.replaceSubrange(m.1.indexRange, with: new)
                }
            }
            
            let numbers = raw.filter(\.isASCIIDigit)
            let num  = "\(numbers.first!)\(numbers.last!)"
            
            return Int(num)!
        }.sum!
    }

}
