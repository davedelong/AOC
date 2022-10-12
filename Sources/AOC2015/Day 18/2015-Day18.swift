//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/17/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day18: Day {
    
    private func around(_ r: Int, _ c: Int, inside: (Int, Int)) -> Array<(Int, Int)> {
        let around = [
            (r-1, c-1),
            (r-1, c),
            (r-1, c+1),
            (r, c-1),
            (r, c+1),
            (r+1, c-1),
            (r+1, c),
            (r+1, c+1)
        ]
        return around.filter { 0 <= $0.0 && $0.0 < inside.0 && 0 <= $0.1 && $0.1 < inside.1 }
    }
    
    func part1() async throws -> String {
        var current = Matrix(input().lines.characters.map { $0.map { $0 == "#" ? Bit.on : Bit.off }})
        
        let rows = current.rowCount
        let cols = current.colCount
        
        for _ in 0 ..< 100 {
            let next = current.copy()
            
            for r in 0 ..< rows {
                for c in 0 ..< cols {
                    let points = around(r, c, inside: (rows, cols))
                    let neighborsOn = points.map { current.get($0.0, col: $0.1) }.count { $0 == .on }
                    
                    let state: Bit
                    if current.get(r, col: c) == .on {
                        // stays on when 2 or 3 neighbors are on, and turns off otherwise
                        state = (neighborsOn == 2 || neighborsOn == 3) ? .on : .off
                    } else {
                        // turns on if exactly 3 neighbors are on; and stays off otherwise
                        state = (neighborsOn == 3) ? .on : .off
                    }
                    next.set(r, col: c, state)
                }
            }
            
            current = next
        }
        
        let lightsOn = current.count(where: { $0 == .on })
        
        return "\(lightsOn)"
    }
    
    func part2() async throws -> String {
        var current = Matrix(input().lines.characters.map { $0.map { $0 == "#" ? Bit.on : Bit.off }})
        
        let rows = current.rowCount
        let cols = current.colCount
        
        for _ in 0 ..< 100 {
            let next = current.copy()
            
            for r in 0 ..< rows {
                for c in 0 ..< cols {
                    let points = around(r, c, inside: (rows, cols))
                    let neighborsOn = points.map { current.get($0.0, col: $0.1) }.count { $0 == .on }
                    
                    let state: Bit
                    if current.get(r, col: c) == .on {
                        // stays on when 2 or 3 neighbors are on, and turns off otherwise
                        state = (neighborsOn == 2 || neighborsOn == 3) ? .on : .off
                    } else {
                        // turns on if exactly 3 neighbors are on; and stays off otherwise
                        state = (neighborsOn == 3) ? .on : .off
                    }
                    next.set(r, col: c, state)
                }
            }
            
            next.set(0, col: 0, .on)
            next.set(0, col: cols - 1, .on)
            next.set(rows-1, col: 0, .on)
            next.set(rows-1, col: cols - 1, .on)
            current = next
        }
        
        let lightsOn = current.count(where: { $0 == .on })
        
        return "\(lightsOn)"
    }
}
