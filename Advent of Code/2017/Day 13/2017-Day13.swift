//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/13/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

class Day13: Day {

    var firewall = Dictionary<Int, Int>()
    
    init() {
        super.init()
        for line in trimmedInputLines {
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
    
    override func part1() -> String {
        return "\(score(for: 0).1)"
    }

    override func part2() -> String {
        for delay in 1 ..< Int.max {
            let s = score(for: delay)
            if s.0 == 0 {
                return "\(delay)"
            }
        }
        fatalError("UNREACHABLE")
    }

}

}
