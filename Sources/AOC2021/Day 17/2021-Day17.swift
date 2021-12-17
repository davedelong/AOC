//
//  Day17.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day17: Day {
    
    lazy var targetArea: PointRect = {
        let ints = input.integers
        return PointRect(xRange: ints[0] ... ints[1], yRange: ints[2] ... ints[3])
    }()
    
    override init() {
        super.init(rawInput: "target area: x=70..96, y=-179..-124")
        // super.init(rawInput: "target area: x=20..30, y=-10..-5")
    }

    override func run() -> (String, String) {
        // observe: the x velocity proceeds as triangular numbers:
        // p = vᵪ + vᵪ-1 + vᵪ-2 + vᵪ-3 ...
        // therefore in order to even *enter* the target area, we have to start with a high enough x velocity
        // such that that velocity's triangular number is greater than or equal to the leading edge of the box
        let lowerXBound = (0 ... targetArea.minX).first(where: { triangular($0) >= targetArea.minX }) ?? 0
        
        // observe:
        // the upper bound of x velocities *that allow positive y velocities* is the first number
        // such that its triangular number is greater than the *trailing* edge of the box
        // or in other words, at that velocity, the probe will be going too fast for the y position to catch up
        // and allow the probe to enter the area
        //
        // however we can still allow x velocities higher than this, but the initial y velocity must be *negative*
        // to compensate for the probe's horizontal movement
        let upperXBound = (0 ... targetArea.minX).first(where: { triangular($0) > targetArea.maxX })!
        
        var maxY = Int.min
        var entranceCount = 0
        for vX in lowerXBound ... targetArea.maxX {
            let yRange: ClosedRange<Int>
            if vX < upperXBound {
                // the probe can still go up and maybe hit the area
                yRange = targetArea.minY ... Int(targetArea.minY.magnitude)
            } else {
                // the vX is too large to hit the area
                // the y velocity must therefore be negative to compensane
                yRange = targetArea.minY ... 0
            }
            for vY in yRange {
                if let y = vectorEntersTargetArea(.init(x: vX, y: vY)) {
//                    print("\(vX),\(vY) = \(y)")
                    entranceCount += 1
                    maxY = max(maxY, y)
                }
            }
        }
        
        return (maxY.description, entranceCount.description)
    }
    
    // returns the maximum Y height of the probe
    // returns nil if the probe never enters the target area
    private func vectorEntersTargetArea(_ vector: Vector2) -> Int? {
        var p = Position.zero
        var v = vector
        var maxY = Int.min
        while (p.x <= targetArea.origin.x + targetArea.width) && (p.y >= targetArea.origin.y) {
            p = p + v
            if v.x > 0 { v.x -= 1 }
            if v.x < 0 { v.x += 1 }
            v.y -= 1
            
            maxY = max(maxY, p.y)
            if targetArea.contains(p) { return maxY }
        }
        return nil
    }
}
