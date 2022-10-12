//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/13/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day13: Day {

    lazy var firewall: Dictionary<Int, Int> = {
        var f = Dictionary<Int, Int>()
        for line in input().lines.raw {
            let p = line.components(separatedBy: ": ")
            f[Int(p[0])!] = Int(p[1])!
        }
        return f
    }()

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
    
    func part1() async throws -> String {
        return "\(score(for: 0).1)"
    }

    func part2() async throws -> String {
        for delay in 1 ..< Int.max {
            let s = score(for: delay)
            if s.0 == 0 {
                return "\(delay)"
            }
        }
        fatalError("UNREACHABLE")
    }

}
