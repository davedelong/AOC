//
//  Day6.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day6: Day {

    override func part1() -> String {
        let groups = input.raw
            .split(on: "\n\n")
            .map { Set($0.split(on: \.isWhitespaceOrNewline).joined()) }
        let total = groups.sum(of: \.count)
        
        return "\(total)"
    }

    override func part2() -> String {
        let groups = input.raw
            .split(on: "\n\n")
            .map { $0.split(on: \.isNewline).intersectingElements() }
        
        let total = groups.sum(of: \.count)
        return "\(total)"
    }

}
