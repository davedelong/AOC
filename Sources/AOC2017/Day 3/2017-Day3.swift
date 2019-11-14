//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day3: Day {
    
    @objc init() { super.init(inputSource: .raw("277678")) }
    
    override func part1() -> String {
        let integer = input.integer!
        
        let squareRootOfInput = sqrt(Double(integer))
        let roundedUp = Int(ceil(squareRootOfInput))
        let root = (roundedUp % 2 == 0) ? roundedUp + 1 : roundedUp
        let layer = (root - 1) / 2
        let lengthOfSide = root
        
        let cornerValue = root * root
        let sideOfSquare = (cornerValue - integer) / lengthOfSide
        let targetCorner = cornerValue - (sideOfSquare * lengthOfSide)
        let middleOfSide = targetCorner - (lengthOfSide / 2)
        
        let distanceToMiddle = abs(integer - middleOfSide)
        let distanceFromMiddleToCenter = layer
        
        let totalDistance = distanceToMiddle + distanceFromMiddleToCenter
        return "\(totalDistance)"
    }
    
    override func part2() -> String {
        let target = input.integer!
        
        var grid = [
            Position(x: 0, y: 0): 1
        ]
        
        func valuesAround(_ position: Position) -> Array<Int> {
            let around = position.surroundingPositions(includingDiagonals: true)
            return around.map { grid[$0] ?? 0 }
        }
        
        var mostRecentSum = 0
        var current = Position(x: 0, y: 0)
        var currentHeading = Heading.east
        
        
        while mostRecentSum < target {
            current = current.move(currentHeading)
            mostRecentSum = valuesAround(current).sum()
            grid[current] = mostRecentSum
            
            let ccwHeading = currentHeading.turn(counterClockwise: 1)
            let ccwPosition = current.move(ccwHeading)
            if grid[ccwPosition] == nil {
                currentHeading = ccwHeading
            }
        }
        
        return "\(mostRecentSum)"
    }
    
}
