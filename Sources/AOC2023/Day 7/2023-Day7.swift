//
//  Day7.swift
//  AOC2023
//
//  Created by Dave DeLong on 11/30/23.
//  Copyright © 2023 Dave DeLong. All rights reserved.
//

struct Day7: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }

    func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

    func part1() async throws -> Part1 {
        let handsAndBids = input().lines.map { line in
            let pieces = line.raw.split(on: \.isWhitespace)
            return (P1Hand(cards: String(pieces[0])), Int(pieces[1])!)
        }
        
        let sorted = handsAndBids.sorted(by: { (lhs, rhs) in
            return lhs.0 < rhs.0
        })
        
        let total = sorted.enumerated().map { (offset, thing) in
            return (offset + 1) * thing.1
        }.sum!
        
        return total
    }

    func part2() async throws -> Part2 {
        let handsAndBids = input().lines.map { line in
            let pieces = line.raw.split(on: \.isWhitespace)
            return (P2Hand(cards: String(pieces[0])), Int(pieces[1])!)
        }
        
        let sorted = handsAndBids.sorted(by: { (lhs, rhs) in
            return lhs.0 < rhs.0
        })
        
        let total = sorted.enumerated().map { (offset, thing) in
            return (offset + 1) * thing.1
        }.sum!
        
        return total
    }

}

struct P1Hand: Comparable {
    
    static func rank(for card: Character) -> Int {
        switch card {
            case "A": return 14
            case "K": return 13
            case "Q": return 12
            case "J": return 11
            case "T": return 10
            case "9": return 9
            case "8": return 8
            case "7": return 7
            case "6": return 6
            case "5": return 5
            case "4": return 4
            case "3": return 3
            case "2": return 2
            default: fatalError()
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.cards == rhs.cards }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.kind.rawValue < rhs.kind.rawValue { return true }
        if lhs.kind.rawValue > rhs.kind.rawValue { return false }
        
        // they're the same… compare cards
        for (l, r) in zip(lhs.cards, rhs.cards) {
            if rank(for: l) < rank(for: r) { return true }
            if rank(for: l) > rank(for: r) { return false }
        }
        
        // they're the same
        return false
    }
    
    enum Kind: Int {
        case fiveOfAKind = 1_000_000
        case fourOfAKind = 100_000
        case fullHouse = 10_000
        case threeOfAKind = 1_000
        case twoPair = 100
        case onePair = 10
        case highCard = 1
    }
    
    let cards: String
    let kind: Kind
    
    init(cards: String) {
        self.cards = cards
        
        let counts = CountedSet(cards)
        let unique = cards.uniqued()
        if unique.count == 1 {
            kind = .fiveOfAKind
        } else if unique.count == 2 {
            // four or fullhouse
            if counts.count(of: unique[0]) == 4 || counts.count(of: unique[1]) == 4 {
                kind = .fourOfAKind
            } else {
                kind = .fullHouse
            }
        } else if unique.count == 3 {
            // three or twopair
            if counts.count(of: unique[0]) == 3 || counts.count(of: unique[1]) == 3 || counts.count(of: unique[2]) == 3 {
                kind = .threeOfAKind
            } else {
                kind = .twoPair
            }
        } else if unique.count == 4 {
            kind = .onePair
        } else {
            kind = .highCard
        }
    }
}

struct P2Hand: Comparable {
    
    static func rank(for card: Character) -> Int {
        switch card {
            case "A": return 14
            case "K": return 13
            case "Q": return 12
            case "T": return 10
            case "9": return 9
            case "8": return 8
            case "7": return 7
            case "6": return 6
            case "5": return 5
            case "4": return 4
            case "3": return 3
            case "2": return 2
            case "J": return 1
            default: fatalError()
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.cards == rhs.cards }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.kind.rawValue < rhs.kind.rawValue { return true }
        if lhs.kind.rawValue > rhs.kind.rawValue { return false }
        
        // they're the same… compare cards
        for (l, r) in zip(lhs.cards, rhs.cards) {
            if rank(for: l) < rank(for: r) { return true }
            if rank(for: l) > rank(for: r) { return false }
        }
        
        // they're the same
        return false
    }
    
    enum Kind: Int {
        case fiveOfAKind = 1_000_000
        case fourOfAKind = 100_000
        case fullHouse = 10_000
        case threeOfAKind = 1_000
        case twoPair = 100
        case onePair = 10
        case highCard = 1
    }
    
    let cards: String
    let kind: Kind
    
    init(cards: String) {
        self.cards = cards
        
        let cardsWithoutJ = cards.filter { $0 != "J" }
        var counts = CountedSet(cardsWithoutJ)
        let numberOfNeededJs = 5 - counts.count
        
        if numberOfNeededJs > 0 {
            let unique = cardsWithoutJ.uniqued()
            var characterToMax: Character = "0"
            var countOfMax = 0
            
            for char in unique {
                if counts.count(of: char) > countOfMax {
                    characterToMax = char
                    countOfMax = counts.count(of: char)
                }
            }
            if characterToMax == "0" {
                characterToMax = "A"
            }
            counts.insert(characterToMax, times: numberOfNeededJs)
        }
        
        let newUniques = counts.uniqued()
        
        if newUniques.count == 1 {
            kind = .fiveOfAKind
        } else if newUniques.count == 2 {
            // four or fullhouse
            if counts.count(of: newUniques[0]) == 4 || counts.count(of: newUniques[1]) == 4 {
                kind = .fourOfAKind
            } else {
                kind = .fullHouse
            }
        } else if newUniques.count == 3 {
            // three or twopair
            if counts.count(of: newUniques[0]) == 3 || counts.count(of: newUniques[1]) == 3 || counts.count(of: newUniques[2]) == 3 {
                kind = .threeOfAKind
            } else {
                kind = .twoPair
            }
        } else if newUniques.count == 4 {
            kind = .onePair
        } else {
            kind = .highCard
        }
    }
}
