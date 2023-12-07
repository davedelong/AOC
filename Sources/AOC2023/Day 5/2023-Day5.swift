//
//  Day5.swift
//  AOC2023
//
//  Created by Dave DeLong on 11/30/23.
//  Copyright © 2023 Dave DeLong. All rights reserved.
//

struct Day5: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }

    func run() async throws -> (Part1, Part2) {
        let i = input()
        let seeds = i.lines[0].integers
        
        let groups = i.lines.dropFirst().split(on: \.isEmpty).map { lineGroup in
            return lineGroup.compactMap { RangeMap(integers: $0.integers) }
        }
        
        @Sendable func location(for seed: Int) -> Int {
            var loc = seed
            for group in groups {
                if let range = group.first(where: { $0.canMap(loc) }) {
                    loc = range.output(for: loc)
                }
            }
            return loc
        }
        
        var part1 = Int.max
        for seed in seeds {
            let location = location(for: seed)
            print("\(seed) -> \(location)")
            part1 = min(part1, location)
        }
        
        let part2 = await withTaskGroup(of: Int.self) { group in
            for (start, length) in seeds.pairs() {
                let r = start ..< (start + length)
                for seed in r {
                    group.addTask { location(for: seed) }
                }
            }
            
            var smallestLoc = Int.max
            for await loc in group { smallestLoc = min(smallestLoc, loc) }
            return smallestLoc
        }
        
        return (part1, part2)
    }

}

struct RangeMap {
    let input: Range<Int>
    let output: Range<Int>
    
    init?(integers: Array<Int>) {
        guard integers.count == 3 else { return nil }
        
        let length = integers[2]
        input = integers[1] ..< (integers[1] + length)
        output = integers[0] ..< (integers[0] + length)
    }
    
    func canMap(_ i: Int) -> Bool { input.contains(i) }
    
    func output(for i: Int) -> Int {
        if canMap(i) {
            let offset = input.distance(from: input.startIndex, to: i)
            return output.lowerBound + offset
        } else {
            return i
        }
    }
}
