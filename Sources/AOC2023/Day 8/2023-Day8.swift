//
//  Day8.swift
//  AOC2023
//
//  Created by Dave DeLong on 11/30/23.
//  Copyright © 2023 Dave DeLong. All rights reserved.
//

struct Day8: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }

    func run() async throws -> (Part1, Part2) {
        let instructions = input().lines.first!.characters.compactMap { Heading(character: $0) }
        
        let r = /(...) = \((...), (...)\)/ // FSQ = (XPV, THH)
        let elements = input().lines.dropFirst().compactMap { line -> (String, (String, String))? in
            guard let match = try? r.firstMatch(in: line.raw) else { return nil }
            return (String(match.1), (String(match.2), String(match.3)))
        }
        let table = Dictionary(uniqueKeysWithValues: elements)
        
        var current = "AAA"
        var nextInstruction = instructions.cycled().makeIterator()
        var steps = 0
        while current != "ZZZ", let next = nextInstruction.next() {
            steps += 1
            
            let choices = table[current]!
            if next == .left {
                current = choices.0
            } else {
                current = choices.1
            }
        }
        
        let aEnds = table.keys.filter { $0.hasSuffix("A") }
        let aLengths = aEnds.map { start -> Int in
            
            var current = start
            var nextInstruction = instructions.cycled().makeIterator()
            var steps = 0
            while current.hasSuffix("Z") == false, let next = nextInstruction.next() {
                steps += 1
                let choices = table[current]!
                if next == .left {
                    current = choices.0
                } else {
                    current = choices.1
                }
            }
            return steps
        }
        let p2 = Int.lcm(of: aLengths)
        
        return (steps, p2)
    }

}
