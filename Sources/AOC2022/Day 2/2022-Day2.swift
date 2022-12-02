//
//  Day2.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day2: Day {

    func part1() async throws -> Int {
        let pairs = input().lines.characters.map { chars in
            return (RPS(chars[0])!, RPS(chars[2])!)
        }
        
        return pairs.map(roundScore(_:)).sum
    }

    func part2() async throws -> Int {
        var score = 0
        for line in input().lines.characters {
            let opponent = RPS(line[0])!
            let result = RPS.Result(line[2])!
            let myChoice = opponent.pieceForTheir(result)
            score += roundScore(them: opponent, me: myChoice)
        }
        return score
    }
    
    private func roundScore(_ pair: (RPS, RPS)) -> Int {
        return roundScore(them: pair.0, me: pair.1)
    }
    
    private func roundScore(them: RPS, me: RPS) -> Int {
        var round = me.pieceValue
        if me.ties(them) { round += 3 }
        if me.beats(them) { round += 6 }
        return round
    }

}

extension RPS.Result {
    init?(_ character: Character) {
        switch character {
            case "X": self = .loss
            case "Y": self = .tie
            case "Z": self = .win
            default: return nil
        }
    }
}

extension RPS {
    fileprivate var pieceValue: Int {
        switch self {
            case .rock: return 1
            case .paper: return 2
            case .scissors: return 3
        }
    }
}
