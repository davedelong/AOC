//
//  Day6.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day6: Day {

    override func part1() -> String {
        let rawGroups = input.raw.components(separatedBy: "\n\n")
        
        let groups = rawGroups.map { group -> Set<Character> in
            let cleaned = group.components(separatedBy: .whitespacesAndNewlines).joined()
            return Set(cleaned)
        }
        
        let total = groups.sum(of: \.count)
        
        return "\(total)"
    }

    override func part2() -> String {
        let rawGroups = input.raw.components(separatedBy: "\n\n")
        
        let groups = rawGroups.map { group -> Set<Character> in
            let answers = group.components(separatedBy: .newlines)
            var first = Set(answers[0])
            for other in answers.dropFirst() {
                first = first.intersection(other)
            }
            return first
        }
        
        let total = groups.sum(of: \.count)
        
        return "\(total)"
    }

}
