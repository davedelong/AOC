//
//  Day24.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day24: Day {
    
    enum Life {
        case bug
        case empty
    }
    
    private func parseInput() -> XYGrid<Life> {
        var g = XYGrid<Life>()
        for (y, line) in input().lines.enumerated() {
            for (x, char) in line.raw.enumerated() {
                g[XY(x: x, y: y)] = char == "#" ? .bug : .empty
            }
        }
        return g
    }
    
    private func iterate(_ grid: XYGrid<Life>) -> XYGrid<Life> {
        var final = grid
        let all = Set(grid.positions)
        for loc in all {
            let around = all.intersection(loc.surroundingPositions())
            let currentState = grid[loc]!
            let count = around.count { grid[$0] == .bug }
            
            switch (currentState, count) {
                case (.empty, let c):
                    if c == 1 || c == 2 {
                        final[loc] = .bug
                    } else {
                        final[loc] = .empty
                    }
                case (.bug, let c):
                    if c == 1 {
                        final[loc] = .bug
                    } else {
                        final[loc] = .empty
                    }
            }
        }
        return final
    }
    
    func part1() async throws -> String {
        var current = parseInput()
        
        var seen = Set<XYGrid<Life>>()
        seen.insert(current)
        
        var count = 0
        while true {
            count += 1
            current = iterate(current)
            print("Loop \(count)")
            current.draw(using: { $0 == .bug ? "#" : "." })
            if seen.contains(current) {
                break
            }
            seen.insert(current)
        }
        
        let positions = current.grid.filter { $0.value == .bug }.map { $0.key }
        let indexes = positions.map { return ($0.y * 5) + ($0.x) }
        let powers = indexes.map { pow(2, $0) }
        let biodiversity = powers.sum
        
        
        return "\(biodiversity)"
    }
    
    func part2() async throws -> String {
        return #function
    }
    
}
