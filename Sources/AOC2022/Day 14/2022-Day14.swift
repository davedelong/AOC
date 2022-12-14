//
//  Day14.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day14: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    enum Cave {
        case rock
        case sand
    }
    
    func parseCave() -> XYGrid<Cave> {
        
        var cave = XYGrid<Cave>()
        
        for line in input().lines {
            let coordinates = line.raw.split(on: " -> ")
            for (start, end) in coordinates.adjacentPairs() {
                let start = Point2(start)
                let end = Point2(end)
                
                let line = Point2.all(between: start, and: end)
                for p in line {
                    cave[p] = .rock
                }
            }
        }
        
        return cave
    }

    func part1() async throws -> Part1 {
        var cave = parseCave()
        let span = cave.span
        
        var count = 0
        while dropSand(into: &cave, floor: span.maxY) {
            count += 1
        }
        
        draw(cave: cave)
        
        return count
    }

    func part2() async throws -> Part2 {
        var cave = parseCave()
        let span = cave.span
        
        let s = Point2(x: 500, y: 0)
        
        var count = 0
        while cave[s] == nil && dropSand2(into: &cave, floor: span.maxY + 2) {
            count += 1
        }
        
        draw(cave: cave)
        
        return count
    }

    func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }
    
    private func dropSand(into cave: inout XYGrid<Cave>, floor: Int) -> Bool {
        var s = Point2(x: 500, y: 0)
        var keepFalling = true
        
        while keepFalling {
            while cave[s] == nil && s.y <= floor {
                s = s.move(.up)
            }
            
            s = s.move(.down)
            let dl = s.move(.up).move(.left)
            let dr = s.move(.up).move(.right)
            
            if s.y >= floor { return false }
            
            if cave[dl] == nil {
                s = dl
            } else if cave[dr] == nil {
                s = dr
            } else {
                cave[s] = .sand
                keepFalling = false
            }
            
        }
        
        return true
    }
    
    private func dropSand2(into cave: inout XYGrid<Cave>, floor: Int) -> Bool {
        var s = Point2(x: 500, y: 0)
        var keepFalling = true
        
        while keepFalling {
            while cave[s] == nil && s.y < floor {
                s = s.move(.up)
            }
            
            s = s.move(.down)
            
            let dl = s.move(.up).move(.left)
            let dr = s.move(.up).move(.right)
            
            if cave[dl] == nil && dl.y < floor {
                s = dl
            } else if cave[dr] == nil && dl.y < floor  {
                s = dr
            } else {
                cave[s] = .sand
                keepFalling = false
            }
            
        }
        
        return true
    }
    
    private func draw(cave: XYGrid<Cave>) {
        cave.draw(using: { c in
            switch c {
                case .none: return "⬜️"
                case .sand: return "🟡"
                case .rock: return "🪨"
            }
        })
    }

}
