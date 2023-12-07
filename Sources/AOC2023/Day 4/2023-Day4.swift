//
//  Day4.swift
//  AOC2023
//
//  Created by Dave DeLong on 11/30/23.
//  Copyright © 2023 Dave DeLong. All rights reserved.
//

struct Day4: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }

    func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

    func part1() async throws -> Part1 {
        return input().lines.raw.map { raw -> Int in
            let pieces = raw.split(separator: ":")[1].split(separator: "|")
            let winning = CountedSet(try! Regex.integers.allMatches(in: pieces[0]).map(\.1))
            let cardNumbers = CountedSet(try! Regex.integers.allMatches(in: pieces[1]).map(\.1))
            
            let intersection = cardNumbers.intersection(winning)
            let totalNumberOfMatches = intersection.count
            
            if totalNumberOfMatches == 0 { return 0 }
            let total = Int(pow(2, Double(totalNumberOfMatches - 1)))
            
            return total
        }.sum!
    }

    func part2() async throws -> Part2 {
        let cards = input().lines.raw.map { raw -> Card in
            let pieces = raw.split(separator: ":")[1].split(separator: "|")
            let winning = CountedSet(try! Regex.integers.allMatches(in: pieces[0]).map(\.1))
            let cardNumbers = CountedSet(try! Regex.integers.allMatches(in: pieces[1]).map(\.1))
            return Card(winning: winning, numbers: cardNumbers)
        }
        
        var totals = CountedSet<Int>()
        let remaining = LinkedList(Array(cards.enumerated()))
        
        while let (index, card) = remaining.popFirst() {
            totals.insert(index)
            
            let count = card.winningNumbers.count
            if count > 0 {
                let cardsToAdd = (index + 1 ... index + count).map { ($0, cards[$0]) }
                remaining.append(contentsOf: cardsToAdd)
            }
        }
        
        return totals.count
    }

}

private struct Card {
    let winning: CountedSet<Int>
    let numbers: CountedSet<Int>
    
    let winningNumbers: CountedSet<Int>
    
    init(winning: CountedSet<Int>, numbers: CountedSet<Int>) {
        self.winning = winning
        self.numbers = numbers
        self.winningNumbers = winning.intersection(numbers)
    }
}
