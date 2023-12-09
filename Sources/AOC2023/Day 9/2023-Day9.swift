//
//  Day9.swift
//  AOC2023
//
//  Created by Dave DeLong on 11/30/23.
//  Copyright © 2023 Dave DeLong. All rights reserved.
//

struct Day9: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }

    func run() async throws -> (Part1, Part2) {
        
        let sequences = input().lines.map(\.integers)
        
        var p1 = 0
        var p2 = 0
        
        for sequence in sequences {
            var derivitives = [sequence]
            var current = sequence
            while derivitives.last!.contains(where: { $0 != 0 }) {
                let diff = current.adjacentPairs().map { $1 - $0 }
                derivitives.append(diff)
                current = diff
            }
            
            // we've derived the zero sequence
            var p1Extrapolation = 0
            var p2Extrapolation = 0
            
            for index in derivitives.indices.reversed() {
                let nextP1 = derivitives[index].last! + p1Extrapolation
                let nextP2 = derivitives[index].first! - p2Extrapolation
                
                p1Extrapolation = nextP1
                p2Extrapolation = nextP2
            }
            
            p1 += p1Extrapolation
            p2 += p2Extrapolation
        }
        
        return (p1, p2)
    }

}
