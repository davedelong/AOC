//
//  Day12.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day12: Day {
    
    enum Instruction {
        case forward(Int)
        case move(Heading, Int)
        case turn(Bool, Int)
    }
    
    lazy var instructions: Array<Instruction> = {
        return input.rawLines.map { line -> Instruction in
            let i = line.first!
            let int = Int(line.dropFirst())!
            
            switch i {
                case "L": return .turn(true, int / 90)
                case "R": return .turn(false, int / 90)
                case "F": return .forward(int)
                default: return .move(Heading(character: i)!, int)
            }
        }
    }()

    override func part1() -> String {
        var p = Position.zero
        var h = Heading.east
        
        for i in instructions {
            switch i {
                case .move(let h, let d):
                    p = p.move(along: h, length: d)
                case .turn(let left, let times):
                    h = h.turn(left: left, times: times)
                case .forward(let d):
                    p = p.move(along: h, length: d)
            }
        }
        
        let d = p.manhattanDistance(to: .zero)
        return "\(d)"
    }

    override func part2() -> String {
        var p = Position.zero
        var w = Vector2(x: 10, y: 1)
        
        for i in instructions {
            switch i {
                case .move(let h, let d):
                    switch h {
                        case .north: w.y += d
                        case .south: w.y -= d
                        case .east: w.x += d
                        case .west: w.x -= d
                        default: fatalError()
                    }
                case .turn(let left, let d):
                    w = w.rotate(left: left, times: d)
                case .forward(let d):
                    p += (w * d)
            }
        }
        
        let d = p.manhattanDistance(to: .zero)
        return "\(d)"
    }

}
