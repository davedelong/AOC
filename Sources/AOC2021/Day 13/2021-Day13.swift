//
//  Day13.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day13: Day {

    let r1: Regex = #"(\d+),(\d+)"#
    lazy var coordinates: Array<Position> = input.rawLines.compactMap {
        guard let match = r1.firstMatch(in: $0) else { return nil }
        return Position(x: match[int: 1]!, y: match[int: 2]!)
    }
    
    let r2: Regex = #"fold along (x|y)=(\d+)"#
    lazy var folds: Array<(String, Int)> = input.rawLines.compactMap {
        guard let match = r2.firstMatch(in: $0) else { return nil }
        return (match[1]!, match[int: 2]!)
    }
    
    lazy var initialGrid: XYGrid<Bool> = {
        var grid = XYGrid<Bool>()
        for p in coordinates {
            grid[p] = true
        }
        return grid
    }()

    override func part1() -> String {
        let after1Fold = foldGrid(initialGrid, axis: folds[0].0, line: folds[0].1)
        return "\(after1Fold.values.count(of: true))"
    }

    override func part2() -> String {
        var grid = initialGrid
        for fold in folds {
            grid = foldGrid(grid, axis: fold.0, line: fold.1)
        }
        
        grid.draw()
        
        let string = grid.render(using: { $0 == true ? "#" : " " })
        return RecognizeLetters(from: string)
    }

    func foldGrid(_ grid: XYGrid<Bool>, axis: String, line: Int) -> XYGrid<Bool> {
        var newGrid = XYGrid<Bool>()
        
        for p in grid.positions {
            if grid[p] == true {
                // should be present in final grid
                
                if axis == "x" {
                    if p.x < line {
                        newGrid[p] = true
                    } else if p.x == line {
                        // do nothing
                    } else {
                        // fold back
                        let delta = 2 * (p.x - line)
                        newGrid[Position(x: p.x - delta, y: p.y)] = true
                    }
                } else {
                    if p.y < line {
                        newGrid[p] = true
                    } else if p.y == line {
                        // do nothing
                    } else {
                        // fold back
                        let delta = 2 * (p.y - line)
                        newGrid[Position(x: p.x, y: p.y - delta)] = true
                    }
                }
                
            }
        }
        return newGrid
    }
}
