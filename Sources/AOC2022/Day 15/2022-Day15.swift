//
//  Day15.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day15: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    func parseThings() -> Array<(Point2, Point2, Int)> {
        return input().lines.map(\.integers).map { ints in
            let s = Point2(x: ints[0], y: ints[1])
            let b = Point2(x: ints[2], y: ints[3])
            let d = s.manhattanDistance(to: b)
            return (s, b, d)
        }
    }
    
    func part1() async throws -> Part1 {
        
        let points = parseThings()
        
        var seen = Set<Int>()
        
        let y = 2000000
        for (s, _, d) in points {
            let distanceToY = abs(y - s.y)
            guard distanceToY < d else { continue }
            
            let wiggle = d - distanceToY
            let l = s.x - wiggle
            let r = s.x + wiggle
            seen.formUnion(l ... r)
        }
        
        for (s, b, _) in points {
            if s.y == y { seen.remove(s.x) }
            if b.y == y { seen.remove(b.x) }
        }
        
        return seen.count
    }

    func part2() async throws -> Part2 {
        let points = parseThings()
        
        let range = 0 ... 4000000
        
        for y in range {
            var unseen = IndexSet(integersIn: range)
            for (s, _, d) in points {
                let distanceToY = abs(y - s.y)
                guard distanceToY < d else { continue }
                
                let wiggle = d - distanceToY
                let l = (s.x - wiggle < 0) ? 0 : s.x - wiggle
                let r = (s.x + wiggle > range.upperBound) ? range.upperBound : s.x + wiggle
                unseen.remove(integersIn: l ... r)
            }
            
            if unseen.count > 0 {
                let x = unseen.first!
                return (x * 4000000) + y
            }
        }
        
        fatalError()
    }

}
