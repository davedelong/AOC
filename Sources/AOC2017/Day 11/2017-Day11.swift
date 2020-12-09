//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/10/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day11: Day {

    enum Direction: String {
        static let reducers: Array<(Direction, Direction, Direction?)> = [
            (.ne, .nw, .n),
            (.se, .n, .ne),
            (.ne, .s, .se), // go ne and s is the same as go se
            (.se, .sw, .s),
            (.nw, .s, .sw),
            (.sw, .n, .nw),
            (.n, .s, nil), // go north cancels with go south
            (.ne, .sw, nil),
            (.nw, .se, nil),
        ]
        case n
        case nw
        case sw
        case s
        case se
        case ne
    }

    func reduce(_ directions: Dictionary<Direction, Int>) -> Dictionary<Direction, Int> {
        var final = directions
        var reduced = false
        
        repeat {
            reduced = false
            for r in Direction.reducers {
                if let a = final[r.0], let b = final[r.1], a > 0, b > 0 {
                    final[r.0] = a - 1
                    final[r.1] = b - 1
                    if let replacement = r.2 {
                        final[replacement] = (final[replacement] ?? 0) + 1
                    }
                    reduced = true
                }
            }
        } while reduced == true
        return final
    }
    
    var directions = Array<Direction>()
    
    @objc override init() {
        super.init()
        directions = input.raw.components(separatedBy: ",").map { Direction(rawValue: $0)! }
    }

    override func run() -> (String, String) {
        var finalDirections = Dictionary<Direction, Int>()
        var latestDistance = 0
        var furthestAway = 0
        
        for d in directions {
            finalDirections[d, default: 0] += 1
            finalDirections = reduce(finalDirections)
            latestDistance = finalDirections.values.sum
            furthestAway = max(furthestAway, latestDistance)
        }

        return ("\(latestDistance)", "\(furthestAway)")
    }

}
