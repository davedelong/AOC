//
//  Day6.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day6: Day {
    
    @objc override init() {
//            super.init(rawInput: """
//1, 1
//1, 6
//8, 3
//3, 4
//5, 5
//8, 9
//"""))
        
        super.init()
    }
    
    lazy var positions: Dictionary<String, Position> = {
        let lines = input.lines.raw
        var positions = Dictionary<String, Position>()
        for (index, line) in lines.indexed() {
            let pieces = line.components(separatedBy: ", ")
            let x = Int(pieces[0])!
            let y = Int(pieces[1])!
            positions["\(index+1)"] = Position(x: x, y: y)
        }
        return positions
    }()
    
    override func part1() -> String {
        let input = positions.values
        
        // given an Array<Position>, find the minX, maxX, minY, and maxY
        let (min, max) = Position.extremes(of: input)
        // given an x/y range, generate all the Positions in that range
        let gridPoints = Position.all(in: min.x...max.x, min.y...max.y)
        
        let gridPointsToClosestPosition = gridPoints.mappingTo { $0.closestPosition(in: input) }
        let edgePoints = Position.edges(of: min.x...max.x, min.y...max.y)
        
        let infinitePositions = Set(edgePoints.compactMap { gridPointsToClosestPosition[$0] })
        let gridPointsWithoutInfinitePoints = gridPointsToClosestPosition.filter { infinitePositions.contains($0.value) == false }
        
        let locations = gridPointsWithoutInfinitePoints.values.compactMap { $0 }
        let counts = CountedSet(counting: locations)
        
        let largestNumberOfNearbyPoints = counts.values.max()!
        return "\(largestNumberOfNearbyPoints)"
    }
    
    override func part2() -> String {
        let positions = Array(self.positions.values)
        
        let (min, max) = Position.extremes(of: positions)
        let gridPoints = Position.all(in: min.x...max.x, min.y...max.y)
        
        let area = gridPoints.map { p -> Int in
            return positions.map { $0.manhattanDistance(to: p) }.sum()
        }.filter { $0 < 10000 }.count
        
        return "\(area)"
    }
    
}
