//
//  Day22.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day22: Day {

    override func run() -> (String, String) {
        return super.run()
    }
    
    func decks() -> (LinkedList<Int>, LinkedList<Int>) {
        let p1 = LinkedList<Int>()
        let p2 = LinkedList<Int>()
        
        let pieces = input.raw.split(on: "\n\n")
        for int in Array(integersIn: pieces[0].dropFirst(10)) {
            p1.append(int)
        }
        for int in Array(integersIn: pieces[1].dropFirst(10)) {
            p2.append(int)
        }
        return (p1, p2)
    }
    
    func score(for deck: LinkedList<Int>) -> Int {
        var sum = 0
        let winner = Array(deck)
        for (offset, int) in winner.reversed().enumerated() {
            sum += int * (offset + 1)
        }
        return sum
    }

    override func part1() -> String {
        let (p1, p2) = decks()
        
        while p1.count > 0 && p2.count > 0 {
            let p1Card = p1.popFirst()!
            let p2Card = p2.popFirst()!
            
            if p1Card > p2Card {
                p1.append(p1Card)
                p1.append(p2Card)
            } else {
                p2.append(p2Card)
                p2.append(p1Card)
            }
        }
        
        let winner = p1.isEmpty ? p2 : p1
        return "\(score(for: winner))"
    }

    override func part2() -> String {
        let (p1, p2) = decks()
        let (_, score) = recusiveCombat(p1: Array(p1), p2: Array(p2))
        return "\(score)"
    }
    
    func recusiveCombat(p1: Array<Int>, p2: Array<Int>) -> (Bool, Int) {
        var p1Snapshots = Set<Array<Int>>()
        var p2Snapshots = Set<Array<Int>>()
        
        let p1Deck = LinkedList(p1)
        let p2Deck = LinkedList(p2)
        
        while p1Deck.count > 0 && p2Deck.count > 0 {
            let p1Snapshot = Array(p1Deck)
            let p2Snapshot = Array(p2Deck)
            
            if p1Snapshots.contains(p1Snapshot) && p2Snapshots.contains(p2Snapshot) {
                return (true, score(for: p1Deck))
            } else {
                p1Snapshots.insert(p1Snapshot)
                p2Snapshots.insert(p2Snapshot)
            }
            
            let p1Card = p1Deck.popFirst()!
            let p2Card = p2Deck.popFirst()!
            
            if p1Deck.count >= p1Card && p2Deck.count >= p2Card {
                let (p1Won, _) = recusiveCombat(p1: Array(Array(p1Deck).prefix(p1Card)), p2: Array(Array(p2Deck).prefix(p2Card)))
                
                if p1Won {
                    p1Deck.append(p1Card)
                    p1Deck.append(p2Card)
                } else {
                    p2Deck.append(p2Card)
                    p2Deck.append(p1Card)
                }
            } else {
                if p1Card > p2Card {
                    p1Deck.append(p1Card)
                    p1Deck.append(p2Card)
                } else {
                    p2Deck.append(p2Card)
                    p2Deck.append(p1Card)
                }
            }
        }
        
        let isP1 = p1Deck.isEmpty ? false : true
        let winner = p1Deck.isEmpty ? p2Deck : p1Deck
        
        return (isP1, score(for: winner))
    }

}
