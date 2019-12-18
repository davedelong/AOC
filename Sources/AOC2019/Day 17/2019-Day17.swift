//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/16/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day17: Day {
    
    enum State {
        case open
        case scaffold
        case robot
        
        var character: String {
            switch self {
                case .open: return "."
                case .scaffold: return "#"
                case .robot: return "R"
            }
        }
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    override func part1() -> String {
        let i = Intcode(memory: input.integers)
        var g = XYGrid<State>()
        
        var x = 0
        var y = 0
        
        var scaffoldPositions = Set<XY>()
        
        i.output = { o in
            let xy = XY(x: x, y: y)
            x += 1
            if o == 35 {
                g[xy] = .scaffold
                scaffoldPositions.insert(xy)
            } else if o == 60 || o == 62 || o == 94 || o == 118 {
                g[xy] = .robot
            } else if o == 46 {
                g[xy] = .open
            } else if o == 10 {
                y += 1
                x = 0
            }
        }
        i.runWithHandlers()
        
        var aligned = Set<XY>()
        for p in scaffoldPositions {
            let around = p.surroundingPositions(includingDiagonals: false)
            if scaffoldPositions.isSuperset(of: around) {
                aligned.insert(p)
            }
        }
        
        let parameters = aligned.map { $0.x * $0.y }
        g.draw(using: { $0!.character })
        
        return "\(parameters.sum())"
    }
    
    override func part2() -> String {
        
        
        // I computed this by drawing out the grid above,
        // writing out the series of turns the robot needs to make,
        // and then looking for common subsequences in it
        
        let movement = "A,B,A,B,A,C,B,C,A,C\n"
        let a = "R,4,L,10,L,10\n"
        let b = "L,8,R,12,R,10,R,4\n"
        let c = "L,8,L,8,R,10,R,4\n"
        let video = "n\n"
        
        var instructions = movement + a + b + c + video
        var dust = 0
        
        let i = Intcode(memory: input.integers)
        i.memory[0] = 2
        i.input = { return Int(instructions.removeFirst().asciiValue!) }
        i.output = { dust = $0 }
        i.runWithHandlers()
        return "\(dust)"
    }
    
}
