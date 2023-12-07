//
//  Day3.swift
//  AOC2023
//
//  Created by Dave DeLong on 11/30/23.
//  Copyright © 2023 Dave DeLong. All rights reserved.
//

struct Day3: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    struct PartNumber: Hashable {
        let value: Int
        let positions: Set<Point2>
    }

    func run() async throws -> (Part1, Part2) {
        let partNumbers = input().lines.enumerated().flatMap { y, line -> Array<PartNumber> in
            let integers = try! Regex.positiveIntegers.allMatches(in: line.raw)
            return integers.compactMap { match -> PartNumber? in
                let value = match.1
                let offset = line.raw.offset(of: match.0.startIndex)
                let end = line.raw.offset(of: match.0.endIndex)
                
                let points = (offset ..< end).map { Point2(x: $0, y: y) }
                return PartNumber(value: value, positions: Set(points))
            }
        }
        
        let grid = XYGrid(data: input().lines.characters)
        
        let parts = grid.positions.flatMap { p -> Array<PartNumber> in
            guard let value = grid[p] else { return [] }
            guard value.isASCIIDigit == false && value != "." else { return [] }
            
            let surrounding = p.surroundingPositions(includingDiagonals: true)
            return partNumbers.filter { $0.positions.intersects(surrounding) }
        }
        
        let unique = parts.uniqued()
        let p1 = unique.sum(of: \.value)!
        
        
        
        let gears = grid.positions.map { p -> Int in
            guard let value = grid[p] else { return 0 }
            guard value == "*" else { return 0 }
            
            let surrounding = p.surroundingPositions(includingDiagonals: true)
            let nearby = partNumbers.filter { $0.positions.intersects(surrounding) }
            return nearby.count == 2 ? nearby[0].value * nearby[1].value : 0
        }
        
        let p2 = gears.sum!
        return (p1, p2)
    }

}
