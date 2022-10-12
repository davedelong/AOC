//
//  Day11.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day11: Day {
    
    enum Feature: Character {
        case floor = "."
        case seat = "L"
        case occupied = "#"
        
        var isFloor: Bool { self == .floor }
        var isSeat: Bool { self == .seat }
        var isOccupied: Bool { self == .occupied }
    }
    
    func part1() async throws -> Int {
        let area = input().lines.characters.map { $0.compactMap(Feature.init(rawValue:)) }
        var grid = Matrix(area)
        var keepGoing = true
        while keepGoing {
            let newGrid = seatPeople_p1(grid)
            keepGoing = (newGrid != grid)
            grid = newGrid
        }
        
        let occupied = grid.count(where: \.isOccupied)
        
        return occupied
    }
    
    private func seatPeople_p1(_ grid: Matrix<Feature>) -> Matrix<Feature> {
        let copy = grid.copy()
        for p in grid.positions {
            if grid[p] == .floor { continue }
            
            let around = p.surroundingPositions(includingDiagonals: true).compactMap { grid.at($0) }
            if grid[p] == .occupied {
                // If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
                if around.count(where: \.isOccupied) >= 4 {
                    copy[p] = .seat
                }
            } else {
                // empty && there are no occupied seats adjacent to it, the seat becomes occupied.
                if around.allSatisfy(\.isOccupied.negated) {
                    copy[p] = .occupied
                }
            }
        }
        return copy
    }

    func part2() async throws -> Int {
        let area = input().lines.characters.map { $0.compactMap(Feature.init(rawValue:)) }
        var grid = Matrix(area)
        var keepGoing = true
        while keepGoing {
            let newGrid = seatPeople_p2(grid)
            keepGoing = (newGrid != grid)
            grid = newGrid
        }
        
        let occupied = grid.count(where:\.isOccupied)
        return occupied
    }
    
    private func seatPeople_p2(_ grid: Matrix<Feature>) -> Matrix<Feature> {
        let copy = grid.copy()
        
        for p in grid.positions {
            if grid[p] == .floor { continue }
            let around = Vector2.adjacents.compactMap { grid.first(from: p, along: $0, where: { $0 != .floor })}
            if grid[p] == .occupied {
                // If a seat is occupied (#) and five or more seats adjacent to it are also occupied, the seat becomes empty.
                if around.count(where:\.isOccupied) >= 5 {
                    copy[p] = .seat
                }
            } else {
                // empty && there are no occupied seats adjacent to it, the seat becomes occupied.
                if around.allSatisfy(\.isOccupied.not) {
                    copy[p] = .occupied
                }
            }
        }
        
        return copy
    }

}
