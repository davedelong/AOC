//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/8/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day9: Day {
    
    private func computeHighestScore(players: Int, lastMarbleScore: Int) -> Int {
        var scores = Array(repeating: 0, count: players)
        var currentPlayer = 0
        
        var currentMarble = CircularList_Old.Node(0)
        for marbleScore in 1...lastMarbleScore {
            if marbleScore % 23 == 0 {
                scores[currentPlayer] += marbleScore
                currentMarble = currentMarble.ccw(7)
                scores[currentPlayer] += currentMarble.value
                (_, currentMarble) = currentMarble.remove()
            } else {
                currentMarble = currentMarble.cw().insert(after: marbleScore)
            }
            currentPlayer = (currentPlayer + 1) % players
        }
        
        return scores.max()!
    }
    
    func part1() async throws -> String {
        let s = computeHighestScore(players: 471, lastMarbleScore: 72026)
        return "\(s)"
    }
    
    func part2() async throws -> String {
        let s = computeHighestScore(players: 471, lastMarbleScore: 7202600)
        return "\(s)"
    }

}
