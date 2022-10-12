//
//  Day6.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day6: Day {

    func part1() async throws -> String {
        let groups = input().raw
            .split(on: "\n\n")
            .map { Set($0.split(on: \.isWhitespaceOrNewline).joined()) }
        let total = groups.sum(of: \.count)
        
        return "\(total)"
    }

    func part2() async throws -> String {
        let groups = input().raw
            .split(on: "\n\n")
            .map { $0.split(on: \.isNewline).intersectingElements() }
        
        let total = groups.sum(of: \.count)
        return "\(total)"
    }

}
