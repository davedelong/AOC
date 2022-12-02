//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/9/17.
//  Copyright © 2016 Dave DeLong. All rights reserved.
//

class Day10: Day {
    enum Destination {
        case output(Int)
        case bot(Int)
    }
    
    typealias Action = (low: Destination, high: Destination)
    
    struct Bot {
        var isFull: Bool { values.count >= 2 }
        var values = Array<Int>()
    }
    
    var bots = SparseArray<Bot>(default: Bot())
    var actions = Dictionary<Int, Action>()
    var bins = Dictionary<Int, Array<Int>>()
    
    var p1: Int?
    
    let takeValue = Regex(#"value (\d+) goes to bot (\d+)"#)
    let action = Regex(#"bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)"#)
    
    func part1() async throws -> Int {
        for line in input().lines.raw.sorted(by: <) {
            if let match = takeValue.firstMatch(in: line) {
                let value = match[int: 1]!
                let bot = match[int: 2]!
                
                bots[bot].values.append(value)
                
            } else if let match = action.firstMatch(in: line) {
                let bot = match[int: 1]!
                
                let low = match[int: 3]!
                let lowDestination = (match[2] == "bot") ? Destination.bot(low) : .output(low)
                
                let high = match[int: 5]!
                let highDestination = (match[4] == "bot") ? Destination.bot(high) : .output(high)
                
                actions[bot] = (low: lowDestination, high: highDestination)
            }
        }
        
        return runBots()
    }
    
    private func runBots() -> Int {
        var p1 = -1
        
        while let botIndex = bots.firstIndex(where: { $0.isFull }) {
            let action = actions[botIndex]!
            
            let values = bots[botIndex].values
            bots[botIndex].values = []
            
            let low = values.min()!
            let high = values.max()!
            
            switch action.low {
                case .bot(let b): bots[b].values.append(low)
                case .output(let o): bins[o, default: []].append(low)
            }
            
            switch action.high {
                case .bot(let b): bots[b].values.append(high)
                case .output(let o): bins[o, default: []].append(high)
            }
            
            if p1 < 0, let botIndex = bots.firstIndex(where: { $0.values == [61, 17] || $0.values == [17, 61] }) {
                p1 = botIndex
            }
        }
        
        return p1
    }
    
    func part2() async throws -> Int {
        return bins[0]!.first! * bins[1]!.first! * bins[2]!.first!
    }

}
