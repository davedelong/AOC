//
//  Day5.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day5: Day {

    override func run() -> (String, String) {
        let passes = input.lines.characters
        
        let filledSeats = Set(passes.map { pass -> Int in
            var row = 0 ..< 128
            for p in pass.prefix(7) {
                if p == "B" { row.location += row.length / 2 }
                row.length /= 2
            }
            
            var seat = 0 ..< 8
            for side in pass.suffix(3) {
                if side == "R" { seat.location += seat.length / 2 }
                seat.length /= 2
            }
            
            return (row.lowerBound * 8) + seat.lowerBound
        })
        
        let largest = filledSeats.max()!
        let emptySeats = Set(0...1016).subtracting(filledSeats)
        
        var mySeat = 0
        for empty in emptySeats {
            if filledSeats.contains(empty-1) && filledSeats.contains(empty+1) {
                mySeat = empty
                break
            }
        }
        
        return ("\(largest)", "\(mySeat)")
    }

}
