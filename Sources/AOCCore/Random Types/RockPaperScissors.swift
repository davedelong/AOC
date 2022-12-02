//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/1/22.
//

import Foundation

public typealias RPS = RockPaperScissors

public enum RockPaperScissors: Hashable {
    
    public enum Result: Hashable {
        case loss
        case tie
        case win
    }
    
    case rock
    case paper
    case scissors
    
    public init?(_ character: Character) {
        switch character {
            case "a", "A", "r", "R", "x", "X": self = .rock
            case "b", "B", "p", "P", "y", "Y": self = .paper
            case "c", "C", "s", "S", "z", "Z": self = .scissors
            default: return nil
        }
    }
    
    public func result(against other: RockPaperScissors) -> Result {
        if ties(other) { return .tie }
        if beats(other) { return .win }
        return .loss
    }
    
    public func pieceForMy(_ result: Result) -> RockPaperScissors {
        switch result {
            case .loss: return losesTo
            case .tie: return self
            case .win: return beats
        }
    }
    
    public func pieceForTheir(_ result: Result) -> RockPaperScissors {
        switch result {
            case .loss: return beats
            case .tie: return self
            case .win: return losesTo
        }
    }
    
    public var losingCounterpart: RockPaperScissors { beats }
    public var winningCounterpart: RockPaperScissors { losesTo }
    
    public var losesTo: RockPaperScissors {
        switch self {
            case .rock: return .paper
            case .paper: return .scissors
            case .scissors: return .rock
        }
    }
    
    public var beats: RockPaperScissors {
        switch self {
            case .rock: return .scissors
            case .paper: return .rock
            case .scissors: return .paper
        }
    }
    
    public func loses(to other: RockPaperScissors) -> Bool {
        return !(ties(other) || beats(other))
    }
    
    public func ties(_ other: RockPaperScissors) -> Bool {
        return self == other
    }
    
    public func beats(_ other: RockPaperScissors) -> Bool {
        switch (self, other) {
            case (.rock, .scissors): return true
            case (.paper, .rock): return true
            case (.scissors, .paper): return true
                
            default: return false
        }
    }
    
}
