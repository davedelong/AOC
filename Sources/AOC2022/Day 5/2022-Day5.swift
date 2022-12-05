//
//  Day5.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day5: Day {
    typealias Part1 = String
    typealias Part2 = String
    
    static var rawInput: String? { nil }
    
    var startingCrates: Array<[Character]> = [
        Array("TFVZCWSQ"),
        Array("BRQ"),
        Array("SMPQTZB"),
        Array("HQRFVD"),
        Array("PTSBDLGJ"),
        Array("ZTRW"),
        Array("JRFSNMQH"),
        Array("WHFNR"),
        Array("BRPQTZJ"),
    ]

//    var startingCrates: Array<[Character]> = [
//        Array("NZ"), Array("DCM"), Array("P")
//    ]
    
    lazy var instructions: Array<(Int, Int, Int)> = {
        let r = Regex(#"move (\d+) from (\d+) to (\d+)"#)
        return input().lines.raw.compactMap { l in
            guard let m = r.firstMatch(in: l) else { return nil }
            return (m[int: 1]!, m[int: 2]! - 1, m[int: 3]! - 1)
        }
    }()
    
    func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

    func part1() async throws -> Part1 {
        
        var stacks = startingCrates
        for (number, source, dest) in instructions {
            let stack = stacks[source]
            
            let removed = stack[0 ..< number]
            
            stacks[source] = Array(stack.dropFirst(number))
            stacks[dest] = removed.reversed() + stacks[dest]
        }
        
        let tops = stacks.map { $0.first! }
        
        return String(tops)
    }

    func part2() async throws -> Part2 {
        
        var stacks = startingCrates
        for (number, source, dest) in instructions {
            let stack = stacks[source]
            
            let removed = stack[0 ..< number]
            
            stacks[source] = Array(stack.dropFirst(number))
            stacks[dest] = removed + stacks[dest]
        }
        
        let tops = stacks.map { $0.first! }
        
        return String(tops)
    }

}
