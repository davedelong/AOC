//
//  Day25.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day25: Day {
    
    lazy var startGrid: XYGrid<Heading> = {
        var g = XYGrid<Heading>()
        for y in 0 ..< input().lines.count {
            let row = input().lines[y]
            for x in 0 ..< row.characters.count {
                if let h = Heading(character: row.characters[x]) {
                    g[x, y] = h
                }
            }
        }
        return g
    }()

    func part1() async throws -> Int {
        var g = startGrid
        let r = g.span
        var turns = 0
        var moves = Int.max
        
        while moves > 0 {
            turns += 1
            (g, moves) = tickGrid(g, rect: r)
//            print("Turn: \(turns)")
//            g.draw(using: { h in
//                if h?.y == 0 { return ">" }
//                if h?.x == 0 { return "v" }
//                return "."
//            })
        }
        
        return turns
    }

    func part2() async throws -> String { return "" }
    
    private func tickGrid(_ grid: XYGrid<Heading>, rect: PointRect) -> (XYGrid<Heading>, Int) {
        let (right, down) = grid.partition(by: { $0.value.y == 0 })
        var intermediate = XYGrid<Heading>()
        var totalNumberOfMoves = 0
        
        // put in the vertical cucumbers
        for (p, h) in down {
            intermediate[p] = h
        }
        
        var final = XYGrid<Heading>()
        for (p, h) in right {
            var newP = p.apply(h)
            if rect.contains(newP) == false { newP.x = rect.minX }
            if grid[newP] == nil {
                intermediate[newP] = h
                final[newP] = h
                totalNumberOfMoves += 1
            } else {
                intermediate[p] = h
                final[p] = h
            }
        }
        
        for (p, h) in down {
            var newP = p.apply(h)
            if rect.contains(newP) == false { newP.y = rect.minY }
            if intermediate[newP] == nil {
                final[newP] = h
                totalNumberOfMoves += 1
            } else {
                final[p] = h
            }
        }
        
        return (final, totalNumberOfMoves)
    }

}
