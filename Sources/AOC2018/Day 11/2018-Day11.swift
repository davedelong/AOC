//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/10/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day11: Day {
    
    @objc init() { super.init(inputSource: .raw("5468")) }
    
    override func run() -> (String, String) {
        return approach2()
    }
    
    private func approach2() -> (String, String) {
        let serialNumber = input.integer!
        let matrix = Matrix<Int>(rows: 300, columns: 300, value: 0)
        
        for x in 0 ..< 300 {
            for y in 0 ..< 300 {
                let rackId = (x+1) + 10
                var powerLevel = rackId * (y+1)
                powerLevel += serialNumber
                powerLevel = powerLevel * rackId
                let hundredsDigit = (powerLevel / 100) % 10
                matrix[x, y] = hundredsDigit - 5
            }
        }
        
        var p1Power = 0
        var p1Position = (0, 0)
        for x in 0 ..< 298 {
            for y in 0 ..< 298 {
                let power = matrix[x,y] + matrix[x+1,y] + matrix[x+2,y] +
                matrix[x,y+1] + matrix[x+1,y+1] + matrix[x+2,y+1] +
                matrix[x,y+2] + matrix[x+1,y+2] + matrix[x+2,y+2]
                
                if power > p1Power {
                    p1Power = power
                    p1Position = (x+1, y+1)
                }
            }
        }
        
        var p2Power = 0
        var p2Position = (0, 0)
        var p2Size = 0
        
        for x in 0 ..< 300 {
            for y in 0 ..< 300 {
                let maxDimension = min(300 - x, 300 - y)
                var previousSquareTotal = matrix[x,y]
                
                guard maxDimension > 0 else { continue }
                for size in 1 ..< maxDimension {
                    // every time we increase the size of the square,
                    // we only have to add the new outer edge of numbers;
                    // we don't have to recompute the value of the previous square again
                    for xE in x ... (x + size) {
                        previousSquareTotal += matrix[xE, y+size]
                    }
                    for yE in y ..< (y + size) {
                        previousSquareTotal += matrix[x+size, yE]
                    }
                    if previousSquareTotal > p2Power {
                        p2Power = previousSquareTotal
                        p2Position = (x+1, y+1) // +1 because printed positions are 1-based
                        p2Size = size+1 // +1 because "size" doesn't account for the original position
                    }
                }
                
            }
        }
        
        return ("\(p1Position.0),\(p1Position.1)", "\(p2Position.0),\(p2Position.1),\(p2Size)")
    }
    
    private func approach1() -> (String, String) {
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
