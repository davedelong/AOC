//
//  Day10.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day10: Day {
    typealias Part1 = Int
    typealias Part2 = String

    func part1() async throws -> Part1 {
        var total = 0
        
        var x = 1
        var cycle = 1
        let specific = Set([20, 60, 100, 140, 180, 220])
        
        for line in input().lines {
            if specific.contains(cycle) { total += cycle * x }
            
            if let int = line.integers.first {
                cycle += 1
                if specific.contains(cycle) { total += cycle * x }
                cycle += 1
                x += int
            } else {
                cycle += 1
            }
        }
        return total
    }

    func part2() async throws -> Part2 {
        let screen = Matrix(rows: 6, columns: 40, value: false)
        
        var x = 1
        var cycle = 0
        
        func draw() {
            let (row, col) = cycle.quotientAndRemainder(dividingBy: screen.colCount)
            let p = Position(row: row, column: col)
            guard screen.has(p) else { return }
            
            let on = p.x == x-1 || p.x == x || p.x == x+1
            screen[p] = on
        }
        
        for line in input().lines {
            draw()
            
            if let int = line.integers.first {
                cycle += 1
                draw()
                cycle += 1
                x += int
            } else {
                cycle += 1
            }
        }
        
        screen.draw()        
        return screen.recognizeLetters()
    }

}
