//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2016 Dave DeLong. All rights reserved.
//

class Day3: Day {
    
    func part1() async throws -> Int {
        return input().lines.count(where: { line in
            let ints = line.integers
            let hypotenuse = ints.max()!
            let sumOfOtherSides = ints.sum - hypotenuse
            return sumOfOtherSides > hypotenuse
        })
    }
    
    func part2() async throws -> Int {
        let ints = input().lines.map(\.integers)
        let transposed = ints.transposed()
        
        var validCount = 0
        for column in transposed {
            for triple in column.chunks(ofCount: 3) {
                let hypotenuse = triple.max()!
                let sumOfOtherSides = triple.sum - hypotenuse
                if sumOfOtherSides > hypotenuse { validCount += 1 }
            }
        }
        
        return validCount
    }

}
