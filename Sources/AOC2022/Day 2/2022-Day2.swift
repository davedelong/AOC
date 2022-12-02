//
//  Day2.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day2: Day {
    
    static var rawInput: String? { nil }
    
    enum RPS: Int {
        case rock = 1
        case paper = 2
        case scissors = 3
        
        init?(character: Character) {
            if character == "A" || character == "X" {
                self = .rock
            } else if character == "B" || character == "Y" {
                self = .paper
            } else if character == "C" || character == "Z" {
                self = .scissors
            } else {
                return nil
            }
        }
        
        var winningCounterpart: RPS {
            switch self {
                case .rock: return .paper
                case .paper: return .scissors
                case .scissors: return .rock
            }
        }
        
        var losingCounterpart: RPS {
            switch self {
                case .rock: return .scissors
                case .paper: return .rock
                case .scissors: return .paper
            }
        }
    }

    func part1() async throws -> Int {
        let pairs = input().lines.characters.map { chars in
            return (RPS(character: chars[0])!, RPS(character: chars[2])!)
        }
        
        return pairs.map(roundScore(_:)).sum
    }

    func part2() async throws -> Int {
        var score = 0
        for line in input().lines.characters {
            let opponent = RPS(character: line[0])!
            
            let myChoice: RPS
            switch line[2] {
                case "X": myChoice = opponent.losingCounterpart
                case "Y": myChoice = opponent
                case "Z": myChoice = opponent.winningCounterpart
                default: fatalError()
            }
            
            score += roundScore(them: opponent, me: myChoice)
        }
        return score
    }
    
    private func roundScore(_ pair: (RPS, RPS)) -> Int {
        return roundScore(them: pair.0, me: pair.1)
    }
    
    private func roundScore(them: RPS, me: RPS) -> Int {
        var round = me.rawValue
        switch (them, me) {
            case (.rock, .rock): round += 3
            case (.rock, .paper): round += 6
            case (.rock, .scissors): round += 0
                
            case (.paper, .rock): round += 0
            case (.paper, .paper): round += 3
            case (.paper, .scissors): round += 6
        
            case (.scissors, .rock): round += 6
            case (.scissors, .paper): round += 0
            case (.scissors, .scissors): round += 3
        }
        return round
    }

    func run() async throws -> (Int, Int) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

}
