//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/10/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2018 {

    public class Day11: Day {
        
        public init() { super.init(inputSource: .raw("5468")) }
        
        override public func run() -> (String, String) {
            
            let gridSerialNumber = input.integer!
            
            var grid = Dictionary<Position, Int>()
            let positions = Position.all(in: 1...300, 1...300)
            
            for p in positions {
                let rackId = p.x + 10
                var powerLevel = rackId * p.y
                powerLevel += gridSerialNumber
                powerLevel = powerLevel * rackId
                let hundredsDigit = (powerLevel / 100) % 10
                grid[p] = hundredsDigit - 5
            }
            
            let iterablePositions = Position.all(in: 2...299, 2...299)
            
            var maxPower = 0
            var powerCoordinate = Position(x: 0, y: 0)
            for position in iterablePositions {
                // since i have convenience code to get the 8 positions around another position,
                // this starts with the *center* of the square
                let threeByThree = [position] + position.surroundingPositions(includingDiagonals: true)
                let values = threeByThree.map { grid[$0]! }
                let totalPower = values.sum()
                if totalPower > maxPower {
                    maxPower = totalPower
                    // since this position is the center of the square,
                    // we have to move north west to get the top-left corner of the square
                    powerCoordinate = position.move(.north).move(.west)
                }
            }
            
            var maxPowerPart2 = 0
            var power2Coordinate = Position(x: 0, y: 0)
            var power2Size = 0
            for p in positions {
                let maxDim = min(300 - p.x, 300 - p.y)
                var previousSquareTotal = grid[p]!
                
                guard maxDim > 0 else { continue }
                for size in 1 ..< maxDim {
                    // every time we increase the size of the square,
                    // we only have to add the new outer edge of numbers;
                    // we don't have to recompute the value of the previous square again
                    for x in p.x ... (p.x + size) {
                        previousSquareTotal += grid[Position(x: x, y: p.y + size)]!
                    }
                    for y in p.y ..< (p.y + size) {
                        previousSquareTotal += grid[Position(x: p.x + size, y: y)]!
                    }
                    if previousSquareTotal > maxPowerPart2 {
                        maxPowerPart2 = previousSquareTotal
                        power2Coordinate = p
                        power2Size = size+1 // +1 because "size" doesn't account for the original position
                    }
                }
            }
            
            return ("\(powerCoordinate.x),\(powerCoordinate.y)", "\(power2Coordinate.x),\(power2Coordinate.y),\(power2Size)")
        }
        
    }

}
