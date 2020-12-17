//
//  Day17.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day17: Day {
    typealias Space<P: PointProtocol> = Dictionary<P, Bool>
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    let testInput = Input("""
.#.
..#
###
""")

    override func part1() -> String {
        let p1 = runInput(input, for: Point3.self)
        return "\(p1)"
    }

    override func part2() -> String {
        let p2 = runInput(input, for: Point4.self)
        return "\(p2)"
    }
    
    func runInput<P: PointProtocol>(_ input: Input, for dimension: P.Type) -> Int {
        var space = Space<P>()
        for (y, row) in input.lines.enumerated() {
            for (x, col) in row.characters.enumerated() {
                var p = P.zero
                p.components[0] = x
                p.components[1] = y
                space[p] = col == "#"
            }
        }
        
        for t in 1 ... 6 {
            print("Tick #\(t)")
            space = tick(space: space)
        }
        return space.count(where: \.value)
    }

    func tick<P>(space: Space<P>) -> Space<P> {
        let (low, high) = P.extremes(of: space.keys)
        let lower = P.init(low.components.map { $0 - 1 })
        let higher = P.init(high.components.map { $0 + 1 })
        let points = P.all(between: lower, and: higher)
        
        var newSpace = space
        for p in points {
            let surround = p.allSurroundingPoints()
            let activeNeighbors = surround.reduce(into: 0) { $0 += (space[$1] == true ? 1 : 0) }
            
            if space[p] == true {
                newSpace[p] = (2...3).contains(activeNeighbors)
            } else {
                newSpace[p] = activeNeighbors == 3
            }
        }
        return newSpace
    }
}
