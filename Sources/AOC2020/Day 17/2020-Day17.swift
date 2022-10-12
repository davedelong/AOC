//
//  Day17.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day17: Day {
    typealias Active = Void
    typealias Space<P: PointProtocol> = Dictionary<P, Active>
    
    let testInput = Input("""
.#.
..#
###
""")

    func part1() async throws -> Int {
        let p1 = runInput(input(), for: Point3.self)
        return p1
    }

    func part2() async throws -> Int {
        let p2 = runInput(input(), for: Point4.self)
        return p2
    }
    
    func runInput<P: PointProtocol>(_ input: Input, for dimension: P.Type) -> Int {
        var space = Space<P>()
        for (y, row) in input.lines.enumerated() {
            for (x, col) in row.characters.enumerated() {
                let p = P([x, y])
                space[p] = col == "#" ? () : nil
            }
        }
        
        for t in 1 ... 6 {
            print("Tick #\(t)")
            space = tick(space: space)
        }
        return space.values.count
    }

    func tick<P>(space: Space<P>) -> Space<P> {
        let (low, high) = P.extremes(of: space.keys)
        let lower = P.init(low.components.map { $0 - 1 })
        let higher = P.init(high.components.map { $0 + 1 })
        let points = P.all(between: lower, and: higher)
        
        var newSpace = space
        for p in points {
            let surround = p.allSurroundingPoints()
            let activeNeighbors = surround.reduce(into: 0) { $0 += (space[$1] != nil ? 1 : 0) }
            
            if space[p] != nil {
                newSpace[p] = (2...3).contains(activeNeighbors) ? () : nil
            } else {
                newSpace[p] = activeNeighbors == 3 ? () : nil
            }
        }
        return newSpace
    }
}
