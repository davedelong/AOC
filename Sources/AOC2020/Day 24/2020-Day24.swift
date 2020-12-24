//
//  Day24.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

extension Point2 {
    func move(_ h: Day24.HexHeading) -> Point2 {
        if y.isMultiple(of: 2) {
            switch h {
                case .e: return Point2(x: x+1, y: y)
                case .w: return Point2(x: x-1, y: y)
                case .ne: return Point2(x: x, y: y+1)
                case .nw: return Point2(x: x-1, y: y+1)
                case .se: return Point2(x: x, y: y-1)
                case .sw: return Point2(x: x-1, y: y-1)
            }
        } else {
            switch h {
                case .e: return Point2(x: x+1, y: y)
                case .w: return Point2(x: x-1, y: y)
                case .ne: return Point2(x: x+1, y: y+1)
                case .nw: return Point2(x: x, y: y+1)
                case .se: return Point2(x: x+1, y: y-1)
                case .sw: return Point2(x: x, y: y-1)
            }
        }
    }
    
    func hexPointsAround() -> Array<Point2> {
        return Day24.HexHeading.allCases.map { self.move($0) }
    }
}

class Day24: Day {
    
    enum Tile {
        case white
        case black
        
        mutating func flip() {
            self = (self == .white) ? .black : .white
        }
    }
    
    enum HexHeading: String, CaseIterable {
        case e
        case se
        case sw
        case w
        case nw
        case ne
    }
    
    lazy var instructions: Array<Array<HexHeading>> = {
        return input.lines.map { line -> Array<HexHeading> in
            var f = Array<HexHeading>()
            var previous: Character?
            for c in line.characters {
                if let p = previous, let h = HexHeading(rawValue: "\(p)\(c)") {
                    f.append(h)
                    previous = nil
                } else if let h = HexHeading(rawValue: "\(c)") {
                    assert(previous == nil)
                    f.append(h)
                    previous = nil
                } else {
                    assert(previous == nil)
                    previous = c
                }
            }
            return f
        }
    }()

    override func run() -> (String, String) {
        
        var grid = Dictionary<Point2, Tile>()
        for list in instructions {
            let p = list.reduce(into: Point2.zero) { $0 = $0.move($1) }
            grid[p, default: .white].flip()
        }
        
        let p1 = grid.values.count(of: .black)
        
        for day in 1 ... 100 {
            grid = flipGrid(grid)
        }
        let p2 = grid.values.count(of: .black)
        
        return ("\(p1)", "\(p2)")
    }
    
    func flipGrid(_ grid: Dictionary<Point2, Tile>) -> Dictionary<Point2, Tile> {
        let (low, high) = Point2.extremes(of: grid.keys)
        let all = Point2.all(between: Point2(x: low.x-1, y: low.y-1), and: Point2(x: high.x+1, y: high.y+1))
        
        var copy = grid
        for p in all {
            let around = p.hexPointsAround()
            let blackAround = around.count(where: { grid[$0, default: .white] == .black })
            if grid[p, default: .white] == .white {
                if blackAround == 2 { copy[p] = .black }
            } else if blackAround == 0 || blackAround > 2 {
                copy[p] = .white
            }
        }
        return copy
    }

}
