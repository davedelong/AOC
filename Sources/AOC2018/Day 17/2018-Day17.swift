//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/16/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day17: Day {
    
    @objc override init() {
        
//            super.init(rawInput: """
//x=495, y=2..7
//y=7, x=495..501
//x=501, y=3..7
//x=498, y=2..4
//x=506, y=1..2
//x=498, y=10..13
//x=504, y=10..13
//y=13, x=498..504
//"""))
        
        super.init()
    }
    
    lazy var clayPositions: Set<Position> = {
        let r = Regex(pattern: #"(x|y)=(\d+), (x|y)=(\d+)\.\.(\d+)"#)
        var positions = Set<Position>()
        for line in input.lines.raw {
            let m = line.match(r)
            let p1 = m[1]!
            let p2 = m[3]!
            
            if p1 == "x" && p2 == "y" {
                let x = m.int(2)!
                let yRange = m.int(4)!...m.int(5)!
                positions.formUnion(yRange.map { Position(x: x, y: $0) })
            } else if p1 == "y" && p2 == "x" {
                let y = m.int(2)!
                let xRange = m.int(4)!...m.int(5)!
                positions.formUnion(xRange.map { Position(x: $0, y: y) })
            }
        }
        return positions
    }()
    
    enum GroundState: String {
        case sand = "."
        case clay = "#"
        case wet = "|"
        case water = "~"
    }
    
    override func run() -> (String, String) {
        let clay = clayPositions
        let (min, max) = Position.extremes(of: clay)
        let hRange = max.x - min.x + 3
        
        let hOffset = min.x - 1
        
        let grid = Matrix<GroundState>(rows: max.y + 1, columns: hRange, value: .sand)
        for c in clayPositions {
            let col = c.x - hOffset
            let row = c.y
            grid[row, col] = .clay
        }
        
        var drop: Set<Position> = [Position(x: 500 - hOffset, y: min.y)]
        while drop.isEmpty == false {
            drop = tickFill(grid, droppingFrom: drop)
//                print("====================")
//                printGrid(grid)
        }
        
        let wet = grid.count(where: { $0 == .wet || $0 == .water })
        let filled = grid.count(where: { $0 == .water })
        return ("\(wet)", "\(filled)")
    }
    
    private func tickFill(_ grid: Matrix<GroundState>, droppingFrom: Set<Position>) -> Set<Position> {
        var newDropPositions = Set<Position>()
        for p in droppingFrom {
            var drop = p
            while grid.has(drop) && grid[drop] != .clay && grid[drop] != .water {
                grid[drop] = .wet
                drop = drop.move(.south)
            }
            
            if grid.has(drop) == false { continue } // off the bottom
            
            var hasProducedNewDrop = false
            while hasProducedNewDrop == false {
                drop = drop.move(.north)
                grid[drop] = .water
                
                var e = drop.move(.east)
                
                // flood to the right
                while grid[e] != .clay {
                    grid[e] = .water
                    e = e.move(.east)
                    let below = e.move(.south)
                    if grid[below] != .clay && grid[below] != .water { break }
                }
                
                // look if we can drop down
                if grid[e] != .clay && grid[e] != .water && grid[e.move(.south)] != .clay {
                    newDropPositions.insert(e)
                    hasProducedNewDrop = true
                }
                
                var w = drop.move(.west)
                
                // flood to the west
                while grid[w] != .clay {
                    grid[w] = .water
                    w = w.move(.west)
                    let below = w.move(.south)
                    if grid[below] != .clay && grid[below] != .water { break }
                }
                if grid[w] != .clay && grid[w] != .water && grid[w.move(.south)] != .clay {
                    newDropPositions.insert(w)
                    hasProducedNewDrop = true
                }
                
                if hasProducedNewDrop == true {
                    // this is a row of wetness, not water
                    while w.x <= e.x {
                        if grid[w] == .water { grid[w] = .wet }
                        w = w.move(.east)
                    }
                }
            }
        }
        return newDropPositions
    }
    
    
    private func printGrid(_ grid: Matrix<GroundState>) {
        let d = grid.data
        for r in d {
            let printable = r.map { $0.rawValue }.joined()
            print(printable)
        }
    }
    
}
