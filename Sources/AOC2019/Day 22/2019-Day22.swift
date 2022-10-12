//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/21/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day22: Day {
    
    enum Instruction: CustomStringConvertible {
        case cut(Int)
        case deal(Int?) // nil = new stack
        
        var description: String {
            switch self {
                case .cut(let c): return "cut \(c)"
                case .deal(nil): return "deal into new stack"
                case .deal(.some(let i)): return "deal with increment \(i)"
            }
        }
    }
    
    private func parse() -> Array<Instruction> {
        /*
         cut 3334
         deal into new stack
         deal with increment 4
         cut -342
         deal with increment 30
         cut -980
         deal into new stack
         cut -8829
         deal with increment 10
         cut -7351
         deal with increment 60
         cut -3766
         deal with increment 52
         cut 8530
         deal with increment 35
         */
        let r = Regex(#"((cut (-?\d+))|(deal (into new stack|with increment (\d+))))"#)
        var instructions = Array<Instruction>()
        for line in input().lines {
            let match = r.firstMatch(in: line.raw)!
            if let cut = match.int(3) {
                instructions.append(.cut(cut))
            } else if let inc = match.int(6) {
                instructions.append(.deal(inc))
            } else {
                instructions.append(.deal(nil))
            }
        }
        return instructions
    }
    
    private func shuffle(deck: Array<Int>, using instructions: Array<Instruction>) -> Array<Int> {
        let c = deck.count
        var d = deck
        var tmp = Array(repeating: 0, count: c)
        for instruction in instructions {
            switch instruction {
                case .deal(.none):
                    for (i, v) in d.enumerated() {
                        tmp[c - 1 - i] = v
                    }
                case .deal(.some(let i)):
                    var idx = 0
                    for card in d {
                        tmp[idx] = card
                        idx += i
                        idx %= c
                    }
                
                case .cut(let n):
                    if n > 0 {
                        for (i, v) in d[n...].enumerated() {
                            tmp[i] = v
                        }
                        let r = c - 1 - n
                        for (i, v) in d[0 ..< n].enumerated() {
                            tmp[r + i] = v
                        }
                    } else if n < 0 {
                        let cutPoint = c - abs(n)
                        for (i, v) in d[cutPoint...].enumerated() {
                            tmp[i] = v
                        }
                        for (i, v) in d[0 ..< cutPoint].enumerated() {
                            tmp[cutPoint + i] = v
                        }
                    } else {
                        fatalError()
                    }
            }
            
            swap(&tmp, &d)
        }
        return d
    }
    
    func part1() async throws -> String {
        let i = parse()
        
        let deck = Array(0 ... 10006)
        let shuffled = shuffle(deck: deck, using: i)
        let pos = shuffled.firstIndex(of: 2019)!
        
        return "\(pos)"
    }
    
    func part2() async throws -> String {
        let instructions = parse()
        
        
        //var deck = Array(0 ... 119_315_717_514_047)
        let deckSize = 10_006
        
        var deck = Array(0 ... deckSize)
        for i in 0 ... 10
            /*101741582076661*/ {
            deck = shuffle(deck: deck, using: instructions)
            print("\(i)\t\(deck[2020])")
        }
        
        return #function
    }
    
}
