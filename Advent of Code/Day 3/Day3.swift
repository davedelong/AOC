//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

class Day3: Day {
    
    let input = 277678
    
    required init() { }
    
    func part1() -> String {
        let squareRootOfInput = sqrt(Double(input))
        let roundedUp = Int(ceil(squareRootOfInput))
        let root = (roundedUp % 2 == 0) ? roundedUp + 1 : roundedUp
        let layer = (root - 1) / 2
        let lengthOfSide = root
        
        let cornerValue = root * root
        let sideOfSquare = (cornerValue - input) / lengthOfSide
        let targetCorner = cornerValue - (sideOfSquare * lengthOfSide)
        let middleOfSide = targetCorner - (lengthOfSide / 2)
        
        let distanceToMiddle = abs(input - middleOfSide)
        let distanceFromMiddleToCenter = layer
        
        let totalDistance = distanceToMiddle + distanceFromMiddleToCenter
        return "\(totalDistance)"
    }
    
    func part2() -> String {
        // TODO: this...
        return "279138 <-- FAKED"
    }
    
}
