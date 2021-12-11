//
//  Day11.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day11: Day {

    override func run() -> (String, String) {
        return super.run()
    }

    override func part1() -> String {
        var octopodes = Matrix(input.lines.digits)
        var total = 0
        for _ in 0 ..< 100 {
            let (o, t) = step(octopodes: octopodes)
            octopodes = o
            total += t
        }
        
        return "\(total)"
    }

    override func part2() -> String {
        
        var octopodes = Matrix(input.lines.digits)
        
        var step = 0
        // keep iterating as long as there's any octopus that's not zero
        while octopodes.allSatisfy({ $0 == 0 }) == false {
            let (o, _) = self.step(octopodes: octopodes)
            octopodes = o
            step += 1
        }
        
        return "\(step)"
    }

    private func step(octopodes: Matrix<Int>) -> (Matrix<Int>, Int) {
        
        var totalFlashCount = 0
        
        let copy = octopodes.copy()
        
        var flash = Array<Position>()
        
        // first, increase each octopus by 1
        // and remember which ones are about to flash
        octopodes.forEach { p, o in
            copy[p] = o+1
            if o+1 == 10 { flash.append(p) }
        }
        
        // start flashing octopods
        while flash.isNotEmpty {
            let next = flash.removeFirst()
            
            // for every octopus around this one...
            let around = next.surroundingPositions(includingDiagonals: true)
            for p in around {
                if let v = copy[safe: p] {
                    // increase its level by 1
                    copy[p] = v+1
                    // if this one hits level 10 and will flash, add it to the list
                    if v+1 == 10 { flash.append(p) }
                }
            }
        }
        
        // find out how many hit (or surpassed) level 10
        // this is how many octopodes flashed
        // reset them to zero
        copy.forEach { p, o in
            if o >= 10 {
                copy[p] = 0
                totalFlashCount += 1
            }
        }
        
        return (copy, totalFlashCount)
    }
}
