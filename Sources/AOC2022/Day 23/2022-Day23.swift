//
//  Day23.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day23: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    let nw = Vector2(x: -1, y: -1)
    let n = Vector2(x: 0, y: -1)
    let ne = Vector2(x: 1, y: -1)
    
    
    let w = Vector2(x: -1, y: 0)
    let e = Vector2(x: 1, y: 0)
    
    let sw = Vector2(x: -1, y: 1)
    let s = Vector2(x: 0, y: 1)
    let se = Vector2(x: 1, y: 1)
    
    var norths: Array<Vector2> { [nw, n, ne] }
    var souths: Array<Vector2> { [sw, s, se] }
    var wests: Array<Vector2> { [nw, w, sw] }
    var easts: Array<Vector2> { [ne, e, se] }

    func part1() async throws -> Part1 {
        var grid = XYGrid<Bool>(data: input().lines.raw.map { $0.map { $0 == "#" } })
        
        var considerations = [
            (norths, n), (souths, s), (wests, w), (easts, e)
        ]
        
        for _ in 1 ... 10 {
            grid = moveElves(grid, considerations: &considerations)
        }
        
        // now, find the smallest bounding rect of the elves
        let boundingRect = grid.span
        let area = boundingRect.count
        let elves = grid.count(where: { $0.value == true })
        
        return area - elves
    }
    
    func part2() async throws -> Part2 {
        var grid = XYGrid<Bool>(data: input().lines.raw.map { $0.map { $0 == "#" } })
        
        var considerations = [
            (norths, n), (souths, s), (wests, w), (easts, e)
        ]
        
        var round = 1
        while true {
            let newGrid = moveElves(grid, considerations: &considerations)
            if newGrid == grid { break }
            
            grid = newGrid
            round += 1
        }
        
        return round
    }
    
    func moveElves(_ grid: XYGrid<Bool>, considerations: inout Array<([Vector2], Vector2)>) -> XYGrid<Bool> {
        // phase one, build proposals
        var proposals = Dictionary<Point2, Point2>()
        for (point, hasElf) in grid where hasElf == true {
            
            let surrounding = point.allSurroundingPoints()
            
            if surrounding.allSatisfy({ grid[$0, default: false] == false }) {
                // blank all around; do not move
                proposals[point] = point
            } else if let (_, v) = considerations.first(where: { vec, _ in
                    vec.allSatisfy({ grid[point.move($0), default: false] == false })
                }) {
                proposals[point] = point.move(v)
            } else {
                proposals[point] = point
            }
        }
        
        let proposalCounts = CountedSet(counting: proposals.values)
        
        // phase two, move elves
        var newGrid = XYGrid<Bool>()
        for (point, hasElf) in grid where hasElf == true {
            
            let thisElfProposal = proposals[point]!
            
            if proposalCounts.count(for: thisElfProposal) == 1 {
                // this elf was the only one to propose moving to this point
                // it may move
                newGrid[thisElfProposal] = true
            } else {
                // elf does not move
                newGrid[point] = true
            }
        }
        
        let popped = considerations.removeFirst()
        considerations.append(popped)
        
        return newGrid
    }

    func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

}
