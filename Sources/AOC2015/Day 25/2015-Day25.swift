//
//  Day25.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day25: Day {
    
    let row = 2947
    let col = 3029
    
    let start = 20151125
    let multiplier = 252533
    let divisor = 33554393
    
    func part1() async throws -> Int {
        
        struct State {
            var rank: Int
            var rankRow: Int
            var point: Point2
        }
        
        let state = State(rank: 1, rankRow: 1, point: Point2(row: 1, column: 1))
        
        let s = sequence(state: state, next: { state in
            let p = state.point
            let r = state.rank
            
            state.rank += 1
            
            if state.point.row <= 1 {
                state.rankRow += 1
                state.point.row = state.rankRow
                state.point.col = 1
            } else {
                state.point.row -= 1
                state.point.col += 1
            }
            
            return (r, p)
        })
        
        let iteration = s.first(where: { $0.1.row == self.row && $0.1.col == self.col })!.0
        
        var current = start
        for _ in 1 ..< iteration {
            current *= multiplier
            current %= divisor
        }
        
        return current
    }
    
    func part2() async throws -> Int {
        return 0
    }

}
