//
//  Day9.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day9: Day {

    override func run() -> (String, String) {
        let ints = input.lines.integers
        
        var p1 = 0
        for index in 25..<ints.count {
            let preamble = ints[index-25..<index]
            let sums = Set(preamble.combinations(choose: 2).map { $0.sum() })
            if sums.contains(ints[index]) == false {
                p1 = ints[index]
                break
            }
        }
        
        var p2 = 0
        // this is like O³. Oh well.
        for i in 0 ..< ints.count - 1 {
            for j in i+1 ..< ints.count {
                let slice = ints[i ... j]
                let sum = slice.sum()
                if sum == p1 {
                    let (low, high) = slice.extremes()
                    p2 = low + high
                    break
                }
            }
        }
        
        return ("\(p1)", "\(p2)")
    }

}
