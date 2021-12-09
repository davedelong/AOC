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
            }
        }
        
        let part1 = lowSum
        
        // part 2
        
        var basins = Array<Set<Position>>()
        matrix.forEach { p, e in
            guard e < 9 else { return } // not a basin position
            
            // find the positions around this point
            let orthos = p.surroundingPositions(includingDiagonals: false)
            
            // look for known basins that contain the surrounding points
            let matchingBasins = basins.indices.filter { basins[$0].intersects(orthos) }
            
            if matchingBasins.isEmpty {
                // there were no basins that are adjacent to this point
                // this is a new basin
                basins.append([p])
            } else if matchingBasins.count == 1 {
                // this point is part of one basin
                // add it directly
                basins[matchingBasins[0]].insert(p)
                
            } else {
                // there were two or more basins that is adjacent to this point
                
                // extract them all
                let matching = basins.pluck(matchingBasins)
                // union them all together (because they're all adjacent to the same point,
                // which means they're all the same basin)
                var unioned = Set(unioning: matching)
                unioned.insert(p)
                
                // save the new, joined basin together
                basins.append(unioned)
            }
        }
        
        // sort the basins by size
        let sortedBasins = basins.sorted(by: { $0.count > $1.count })
        
        // get the first (largest) three
        let firstThree = sortedBasins.prefix(3)
        
        // multiply their sizes together
        let part2 = firstThree.product(of: \.count)
        
        return ("\(part1)", "\(part2)")
    }

}
