//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2016 Dave DeLong. All rights reserved.
//

class Day1: Day {
    
    func part1() async throws -> Int {
        let words = input().csvWords.trimmed
        
        var position = Point2.zero
        var heading = Heading.north
        
        for step in words {
            if step.characters[0] == "L" { heading = heading.rotateLeft() }
            if step.characters[0] == "R" { heading = heading.rotateRight() }
            
            let move = Int(step.raw.dropFirst())!
            position = position.move(along: heading, length: move)
        }
        
        return position.manhattanDistance(to: .zero)
    }
    
    func part2() async throws -> Int {
        let words = input().csvWords.trimmed
        
        var position = Point2.zero
        var heading = Heading.north
        
        var visited = Set<Point2>()
        print("START", position)
        
        for step in words {
            if step.characters[0] == "L" { heading = heading.rotateLeft() }
            if step.characters[0] == "R" { heading = heading.rotateRight() }
            let move = Int(step.raw.dropFirst())!
            
            for _ in 0 ..< move {
                position = position.move(along: heading)
                if visited.contains(position) {
                    return position.manhattanDistance(to: .zero)
                } else {
                    visited.insert(position)
                }
            }
        }
        
        fatalError()
    }

}
