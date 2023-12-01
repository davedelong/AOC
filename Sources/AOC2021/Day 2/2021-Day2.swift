//
//  Day2.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

class Day2: Day {

    enum Command {
        case forward(Int)
        case up(Int)
        case down(Int)
    }
    
    var commands: Array<Command> {
        let r = /(forward|down|up) (\d+)/
        return input().lines.raw.map { str in
            let match = try! r.firstMatch(in: str)
            let dir = match!.1
            let val = match!.2.int!
            
            switch dir {
                case "forward": return .forward(val)
                case "down": return .down(val)
                case "up": return .up(val)
                default: fatalError()
            }
        }
    }

    func part1() async throws -> Int {
        var h = 0
        var d = 0
        for command in commands {
            switch command {
                case .forward(let v): h += v
                case .up(let v): d -= v
                case .down(let v): d += v
            }
            d = max(d, 0)
        }
        return h * d
    }

    func part2() async throws -> Int {
        var h = 0
        var d = 0
        var a = 0
        for command in commands {
            switch command {
                case .down(let v): a += v
                case .up(let v): a -= v
                case .forward(let v):
                    h += v
                    d += (v * a)
            }
            d = max(d, 0)
        }
        return h * d
    }

}
