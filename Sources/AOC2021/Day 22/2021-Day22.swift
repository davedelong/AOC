//
//  Day22.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day22: Day {
    
    struct Instruction {
        let shouldBeOn: Bool
        var span: PointSpan3
    }
    
    lazy var instructions: Array<Instruction> = {
        return input.lines.map { l -> Instruction in
            let on = l.raw.hasPrefix("on")
            let ints = l.integers
            return Instruction(shouldBeOn: on,
                               span: PointSpan3([ints[0]...ints[1], ints[2]...ints[3], ints[4]...ints[5]]))
        }
    }()
    
    override func part1() -> String {
//        return "589411"
        let space = PointSpan3([-50 ... 50, -50 ... 50, -50 ... 50])
        return runInstructions(limitedTo: space).description
    }
    
    override func part2() -> String {
        return runInstructions(limitedTo: nil).description
    }
    
    func runInstructions(limitedTo space: PointSpan3?) -> Int {
        // we're going to keep track of cubes
        var cubes = CountedSet<PointSpan3>()
        
        for instruction in instructions {
            let limitedSpan: PointSpan3
            if let s = space {
                guard let i = s.intersection(with: instruction.span) else { continue }
                limitedSpan = i
            } else {
                limitedSpan = instruction.span
            }
            // this is a new cube to add to the map
            // go through every cube already on the map
            // if this cube intersects with the existing cube,
            // then we need to "cancel out" the intersection with that cube
            // we'll do this by adding a new cube into the map that represents the intersection
            // and giving it the opposite value of the existing cube
            // therefore when we add them all up, they'll cancel out
            
            // then if this is an "on" cube, we add the "on-ness" to the list
            
            for (cube, count) in cubes {
                if let intersection = cube.intersection(with: limitedSpan) {
                    cubes[intersection, default: 0] -= count
                }
            }
            
            if instruction.shouldBeOn {
                cubes[limitedSpan, default: 0] += 1
            }
        }
        
        return cubes.map { $0.numberOfPoints * $1 }.sum
        
    }
    
}
