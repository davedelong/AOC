//
//  Day9.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day9: Day {

    override func run() -> (String, String) {
        let intChars = input.lines.digits
        let matrix = Matrix(intChars)
        
        var lowSum = 0
        var lowPoints = Array<Position>()
        
        // go through every point
        matrix.forEach { p, e in
            // find the points surrounding this point
            let orthoPoints = p.surroundingPositions(includingDiagonals: false)
            // get the existing values surrounding this point
            let others = orthoPoints.compactMap { matrix[safe: $0] }
            // if all the surround points are larger than this value
            if others.allSatisfy({ $0 > e }) {
                // then this is a low position
                lowSum += e + 1
                lowPoints.append(p)
            }
        }
        
        let part1 = lowSum
        
        // part 2
        var basinSizes = Array<Int>()
        for point in lowPoints {
            var basinPositions = Set<Position>()
            var toConsider = [point]
            while toConsider.isEmpty == false {
                let next = toConsider.removeFirst()
                basinPositions.insert(next)
                let ortho = next.surroundingPositions(includingDiagonals: false)
                for neighbor in ortho {
                    if let value = matrix[safe: neighbor], value < 9, basinPositions.contains(neighbor) == false {
                        toConsider.append(neighbor)
                    }
                }
            }
            
            basinSizes.append(basinPositions.count)
        }
        
        let sortedSizes = basinSizes.sorted(by: >)
        let part2 = sortedSizes.prefix(3).product
        return ("\(part1)", "\(part2)")
    }

}
