//
//  Day6.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day6: Day {
    
    struct Command {
        let rowRange: ClosedRange<Int>
        let columnRange: ClosedRange<Int>
        let p1Action: (Bit) -> Bit
        let p2Action: (Int) -> Int
    }
    
    lazy var commands: Array<Command> = {
        let r = Regex(pattern: #"(toggle|turn on|turn off) (\d+),(\d+) through (\d+),(\d+)"#)
        return input.lines.raw.map { l -> Command in
            let m = l.match(r)
            let p1Action: (Bit) -> Bit
            let p2Action: (Int) -> Int
            
            switch m[1]! {
                case "turn on":
                    p1Action = { _ in return .on }
                    p2Action = { $0 + 1 }
                case "turn off":
                    p1Action = { _ in return .off }
                    p2Action = { max($0 - 1, 0) }
                default:
                    p1Action = { return $0.toggled() }
                    p2Action = { $0 + 2 }
            }
            return Command(rowRange: m.int(2)!...m.int(4)!, columnRange: m.int(3)!...m.int(5)!, p1Action: p1Action, p2Action: p2Action)
        }
    }()
    
    override func part1() -> String {
        var m = Dictionary<Position, Bit>()
        for cmd in commands {
            let positions = Position.all(in: cmd.rowRange, cmd.columnRange)
            for p in positions {
                m[p] = cmd.p1Action(m[p] ?? .off)
            }
        }
        let count = m.values.count { $0 == .on }
        return "\(count)"
    }
    
    override func part2() -> String {
        var m = Dictionary<Position, Int>()
        for cmd in commands {
            let positions = Position.all(in: cmd.rowRange, cmd.columnRange)
            for p in positions {
                m[p] = cmd.p2Action(m[p] ?? 0)
            }
        }
        let total = m.values.sum()
        return "\(total)"
    }
    
}
