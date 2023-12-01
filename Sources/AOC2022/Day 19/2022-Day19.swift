//
//  Day19.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day19: Day {
    typealias Part1 = String
    typealias Part2 = String
    
    enum Cost {
        case ore(Int)
        case clay(Int)
        case obsidian(Int)
    }
    
    struct Blueprint {
        let id: Int
        let ore: [Cost]
        let clay: [Cost]
        let obsidian: [Cost]
        let geode: [Cost]
    }
    
    static var rawInput: String? { nil }
    
    func parseBlueprints() -> Array<Blueprint> {
        let r = Regex(#"Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian."#)
        
        return input().lines.raw.compactMap { line -> Blueprint? in
            guard let m = r.firstMatch(in: line) else { return nil }
            return Blueprint(id: m[int: 1]!,
                             ore: [.ore(m[int: 2]!)],
                             clay: [.ore(m[int: 3]!)],
                             obsidian: [.ore(m[int: 4]!), .clay(m[int: 5]!)],
                             geode: [.ore(m[int: 6]!), .obsidian(m[int: 7]!)])
        }
        
    }

    func part1() async throws -> Part1 {
        _ = input()
        return #function
    }

    func part2() async throws -> Part2 {
        return #function
    }

    func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

}
