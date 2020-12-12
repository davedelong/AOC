//
//  Day12.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day12: Day {
    
    enum Instruction {
        case ahead(Int)
        case move(Heading, Int)
        case turn(Bool, Int)
    }
    
    lazy var instructions: Array<Instruction> = {
        return input.rawLines.map { line -> Instruction in
            let i = line.first!
            let int = Int(line.dropFirst())!
            
            switch i {
                case "N": return .move(.north, int)
                case "E": return .move(.east, int)
                case "W": return .move(.west, int)
                case "S": return .move(.south, int)
                case "L": return .turn(true, int)
                case "R": return .turn(false, int)
                case "F": return .ahead(int)
                default: fatalError()
            }
        }
    }()

    override func part1() -> String {
        var p = Position.zero
        var h = Heading.east
        
        for i in instructions {
            switch i {
                case .move(let h, let d):
                    p = p.move(h, length: d)
                case .turn(let left, let d):
                    let times = d / 90
                    if left {
                        for _ in 0 ..< times { h = h.turnLeft() }
                    } else {
                        for _ in 0 ..< times { h = h.turnRight() }
                    }
                case .ahead(let d):
                    p = p.move(h, length: d)
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
                    }
                case .turn(let left, let d):
                    var times = (d / 90) % 4
                    if left == false { times = 4 - times }
                    
                    switch times {
                        case 0: continue
                        case 1: w = Vector2(x: -w.y, y: w.x)
                        case 2: w = Vector2(x: -w.x, y: -w.y)
                        case 3: w = Vector2(x: w.y, y: -w.x)
                        default: fatalError()
                    }
                case .ahead(let d):
                    p += (w * d)
            }
        }
        
        let d = p.manhattanDistance(to: .zero)
        return "\(d)"
    }

}
