//
//  Day6.swift
//  AOC2023
//
//  Created by Dave DeLong on 11/30/23.
//  Copyright © 2023 Dave DeLong. All rights reserved.
//

struct Day6: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }

    func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

    func part1() async throws -> Part1 {
        let numbers = input().lines.map(\.integers)
        let timeAndDistance = zip(numbers[0], numbers[1])
        
        var product = 1
        for (time, distance) in timeAndDistance {
            var isFurther = 0
            for speed in 0 ..< time {
                let timeToMove = time - speed
                let thisDistance = timeToMove * speed
                if thisDistance > distance { isFurther += 1 }
            }
            product *= isFurther
        }
        
        return product
    }

    func part2() async throws -> Part2 {
        let numbers = input().lines.characters.map { Int(String($0.filter(\.isASCIIDigit)))! }
        
        let distance = numbers[1]
        let time = numbers[0]
        
        var isFurther = 0
        for speed in 0 ..< time {
            let timeToMove = time - speed
            let thisDistance = timeToMove * speed
            if thisDistance > distance { isFurther += 1 }
        }
        
        return isFurther
    }

}
