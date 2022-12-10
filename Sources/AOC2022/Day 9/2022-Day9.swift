//
//  Day9.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day9: Day {
    typealias Part1 = Int
    typealias Part2 = Int

    func part1() async throws -> Part1 { moveRope(length: 2) }

    func part2() async throws -> Part2 { moveRope(length: 10) }
    
    func moveRope(length: Int) -> Int {
        if length <= 0 { return 0 }
        
        var rope = Array(repeating: Point2.zero, count: length)
        var tailVisited = Set<Point2>([rope.last!])
        
        for words in input().lines.map(\.words) {
            let direction = Vector2(character: words[0].raw.first!)!
            let count = words[1].integer!
            
            for _ in 0 ..< count {
                rope[0] = rope[0].move(direction)
                
                for (p, n) in rope.indices.adjacentPairs() {
                    let v = rope[n].vector(towards: rope[p])
                    if v.manhattanDistance > (v.isOrthogonal ? 1 : 2) {
                        rope[n] = rope[n].move(v.signum)
                    }
                }
                
                tailVisited.insert(rope.last!)
                
            }
        }
        
        return tailVisited.count
    }

}
