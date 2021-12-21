//
//  Day21.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day21: Day {

    override func part1() -> String {
        
        let board = CircularList.Node(values: 1...10)
        /*
         Player 1 starting position: 1
         Player 2 starting position: 3
         */
        var p1 = board.find(value: 1)!
        var p2 = board.find(value: 3)!
        
        var p1Score = 0
        var p2Score = 0
        
        var die = (1...100).cycled().makeIterator()
        var turnCount = 1
        var rollCount = 0
        
        func roll() -> Int {
            rollCount += 3
            return die.next()! + die.next()! + die.next()!
        }
        
        while true {
            
            // p1 turn
            turnCount += 1
            p1 = p1.cw(roll())
            p1Score += p1.value
            if p1Score >= 1000 { break }
            
            // p2 turn
            turnCount += 1
            p2 = p2.cw(roll())
            p2Score += p2.value
            if p2Score >= 1000 { break }
        }
        
        let loserScore = min(p1Score, p2Score)
        return (loserScore * rollCount).description
    }

    override func part2() -> String {
        
        struct GameState: Hashable {
            var p1: Int
            var p2: Int
            
            var s1: Int
            var s2: Int
        }
        
        // keeping track of "given this game state, how many times does p1 win vs p2 win?"
        var outcomeCounts = Dictionary<GameState, (Int, Int)>()
        
        func countWins(p1: Int, p2: Int, s1: Int, s2: Int) -> (p1: Int, p2: Int) {
            if s1 >= 21 { return (1, 0) } // player 1 always wins
            if s2 >= 21 { return (0, 1) } // player 2 always wins
            
            // see if we've calculated this game before
            let state = GameState(p1: p1, p2: p2, s1: s1, s2: s2)
            if let e = outcomeCounts[state] { return e }
            
            var answer = (0, 0)
            /*
             if you roll 3 3-sided dies, these are all the possible totals and ways to make them
             3: 1x (1,1,1)
             4: 3x (1,1,2; 1,2,1; 2,1,1)
             5: 6x (1,1,3; 1,2,2; 1,3,1; 2,1,2; 2,2,1; 3,1,1)
             6: 7x (1,2,3; 1,3,2; 2,1,3; 2,2,2; 2,3,1; 3,1,2; 3,2,1)
             7: 6x (1,3,3; 2,2,3; 2,3,2; 3,1,3; 3,2,2; 3,3,1)
             8: 3x (2,3,3; 3,2,3; 3,3,2)
             9: 1x (3,3,3)
             
             so, we only need to iterate through the possible *sums* of the dice (3...9),
             but any answer we get needs to be multiplied by the total number of ways
             we could have rolled that total
             */
            for (rollTotal, times) in [3: 1, 4: 3, 5: 6, 6: 7, 7: 6, 8: 3, 9: 1] {
                // find player 1's new position and score
                let total = p1 + rollTotal
                let newP1 = (total > 10) ? total-10 : total
                let newS1 = s1 + newP1
                
                // recurse, but swap player 1 and player 2 (because p2 goes next and "becomes" player 1)
                // this allows us to re-use game states for p1/p2
                let (p2Wins, p1Wins) = countWins(p1: p2, p2: newP1, s1: s2, s2: newS1)
                // add up the respective win counts
                answer = (answer.0 + p1Wins * times, answer.1 + p2Wins * times)
            }
            
            outcomeCounts[state] = answer
            return answer
        }
        
        let (p1Wins, p2Wins) = countWins(p1: 1, p2: 3, s1: 0, s2: 0)
        return max(p1Wins, p2Wins).description
    }

}
