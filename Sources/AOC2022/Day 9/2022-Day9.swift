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

    func part1() async throws -> Part1 {
        var head = Point2.zero
        var tail = Point2.zero
        
        var tailVisited = Set<Point2>([tail])
        
        for words in input().lines.map(\.words) {
            let direction = Vector2(character: words[0].raw.first!)!
            let count = words[1].integer!
            
            for _ in 0 ..< count {
                head = head.move(along: direction)
                if tail.x == head.x || tail.y == head.y {
                    if head.manhattanDistance(to: tail) > 1 {
                        tail = tail.move(direction)
                    }
                } else {
                    // might be diagonally adjacent
                    if head.manhattanDistance(to: tail) > 2 {
                        tail = head.move(direction.turnAround())
                    }
                }
                tailVisited.insert(tail)
            }
        }
        
        return tailVisited.count
    }

    func part2() async throws -> Part2 {
        var rope = Array(repeating: Point2.zero, count: 10)
        
        var tailVisited = Set<Point2>([rope.last!])
        
        for words in input().lines.map(\.words) {
            let direction = Vector2(character: words[0].raw.first!)!
            let count = words[1].integer!
            
            for _ in 0 ..< count {
                rope[0] = rope[0].move(direction)
                
                for (p, n) in rope.indices.adjacentPairs() {
                    if rope[p].x == rope[n].x || rope[p].y == rope[n].y {
                        if rope[p].manhattanDistance(to: rope[n]) > 1 {
                            let v = rope[n].vector(towards: rope[p])
                            rope[n] = rope[n].move(v.unit())
                        }
                    } else {
                        if rope[p].manhattanDistance(to: rope[n]) > 2 {
                            // move diagonally towards rope[p]
                            let v = rope[n].vector(towards: rope[p])
                            rope[n] = rope[n].move(v.unit())
                        }
                    }
                }
                
                tailVisited.insert(rope.last!)
                
            }
        }
        
        return tailVisited.count
    }

}
