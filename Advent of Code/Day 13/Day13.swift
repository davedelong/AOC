//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/13/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

class Day13: Day {

    var firewall = Dictionary<Int, Int>()
    
    required init() {
        for line in Day13.inputLines() {
            let p = line.components(separatedBy: ": ")
            firewall[Int(p[0])!] = Int(p[1])!
        }
    }


    func score(for delay: Int) -> (Int, Int) {
        var collisions = 0
        var score = 0
        for (layer, depth) in firewall {
            let cycle = (depth * 2) - 2
            let position = (layer + delay) % cycle
            if position == 0 {
                collisions += 1
                score += (depth * layer)
            }
        }
        return (collisions, score)
    }
    
    func part1() {
        print("score: \(score(for: 0).1)")
    }

    func part2() {
        for delay in 1 ..< Int.max {
            let s = score(for: delay)
            if s.0 == 0 {
                print("delay: \(delay)")
                break
            }
        }
    }

}
