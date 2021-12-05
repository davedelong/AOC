//
//  Day5.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day5: Day {
    
    struct Vent {
        let start: Position
        let end: Position
    }
    
    var vents: Array<Vent> {
        let r: Regex = #"(\d+),(\d+) -> (\d+),(\d+)"#
        return input.lines.raw.map { line in
            let m = r.firstMatch(in: line)!
            return Vent(start: Position(x: m[int: 1]!, y: m[int: 2]!),
                        end: Position(x: m[int: 3]!, y: m[int: 4]!))
        }
    }

    override func part1() -> String {
        let orthoVents = vents.filter { $0.start.x == $0.end.x || $0.start.y == $0.end.y }
        let total = self.countOverlaps(orthoVents)
        return "\(total)"
    }

    override func part2() -> String {
        let total = self.countOverlaps(self.vents)
        return "\(total)"
    }
    
    private func countOverlaps(_ vents: Array<Vent>) -> Int {
        var sparse = Dictionary<Position, Int>()
        for v in vents {
            let heading = v.start.unitVector(to: v.end)
            var p = v.start
            while p != v.end {
                sparse[p, default: 0] += 1
                p += heading
            }
            // include the end
            sparse[p, default: 0] += 1
        }
        
        return sparse.values.count(where: { $0 > 1 })
    }

}
