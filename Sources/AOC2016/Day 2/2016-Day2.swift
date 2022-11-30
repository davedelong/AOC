//
//  Day2.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2016 Dave DeLong. All rights reserved.
//

class Day2: Day {
    
    func part1() async throws -> String {
        
        // this is upside-down because moving "up" *increases* the row number
        // since rows are zero-based from the top-left, "up" really means moving *down* to the next row
        // this could also be solved be reversing up/down directions
        let grid: XYGrid<Int> = [
            [7, 8, 9],
            [4, 5, 6],
            [1, 2, 3],
        ]
        
        
        let lines = input().lines
        
        var code = Array<Int>()
        var position = Point2(x: 1, y: 1)
        
        for line in lines {
            let directions = line.characters.compactMap { Heading(character: $0) }
            for d in directions {
                let next = position.move(d)
                if grid[next] != nil { position = next }
            }
            code.append(grid[position]!)
        }
        
        return code.map { "\($0)" }.joined()
    }
    
    func part2() async throws -> String {
        
        // this is upside-down because moving "up" *increases* the row number
        // since rows are zero-based from the top-left, "up" really means moving *down* to the next row
        // this could also be solved be reversing up/down directions
        let grid: XYGrid<Character?> = [
            [nil, nil, "D", nil, nil],
            [nil, "A", "B", "C", nil],
            ["5", "6", "7", "8", "9"],
            [nil, "2", "3", "4", nil],
            [nil, nil, "1", nil, nil],
        ]
        
        
        let lines = input().lines
        
        var code = Array<Character>()
        var position = Point2(x: 1, y: 1)
        
        for line in lines {
            let directions = line.characters.compactMap { Heading(character: $0) }
            for d in directions {
                let next = position.move(d)
                if let p = grid[next], p != nil { position = next }
            }
            code.append(grid[position]!!)
        }
        
        return code.map { "\($0)" }.joined()
    }

}
