//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day3: Day {
    
    lazy var headings: Array<Heading> = {
        return input().characters.compactMap { Heading(character: $0) }
    }()
    
    func part1() async throws -> String {
        var presentCount = CountedSet<Position>()
        
        var current = Position(x: 0, y: 0)
        for heading in headings {
            presentCount[current, default: 0] += 1
            current = current.move(heading)
        }
        return "\(presentCount.count)"
    }
    
    func part2() async throws -> String {
        var presentCount = [
            Position(x: 0, y: 0): 2
        ]
        
        var santaPositions = [
            Position(x: 0, y: 0),
            Position(x: 0, y: 0)
        ]
        
        var currentSanta = 0
        for heading in headings {
            let position = santaPositions[currentSanta].move(heading)
            presentCount[position, default: 0] += 1
            santaPositions[currentSanta] = position
            currentSanta = (currentSanta + 1) % santaPositions.count
        }
        
        return "\(presentCount.count)"
    }
    
}
