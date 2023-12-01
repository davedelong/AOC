//
//  Day20.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day20: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    func parseInput() -> Array<Int> {
        return input().integers
    }

    func part1() async throws -> Part1 {
        var list = CircularList(parseInput())
        let indices = list.indices
        list.forEach { print($0, terminator: ", ")}
        print("")
        
        for idx in indices {
            let delta = list[idx]
            
            let (wraps, offset) = delta.quotientAndRemainder(dividingBy: list.count)
            var target = list.index(idx, offsetBy: offset)
            target = list.index(target, offsetBy: wraps)
            
            if delta < 0 {
                list.insert(delta, before: target)
                list.removeValue(at: idx)
            } else if delta > 0 {
                list.insert(delta, after: target)
                list.removeValue(at: idx)
            } else {
                // do nothing
            }
            
            list.forEach { print($0, terminator: ", ")}
            print("")
        }
        
        let zero = list.nextIndex(startingAt: nil, searchDirection: .forward, matching: { $0 == 0 })!
        let oneK = list.index(zero, offsetBy: 1000)
        let twoK = list.index(zero, offsetBy: 2000)
        let threeK = list.index(zero, offsetBy: 3000)
        
        let coords = [oneK, twoK, threeK]
        let bits = coords.map { list[$0] }
        print(bits)
        
        let p1 = bits.sum
        
        return p1
    }

    func part2() async throws -> Part2 {
        let key = 811589153
        var list = CircularList(parseInput().map { $0 * key })
        let indices = list.indices
        
        for _ in 1 ... 10 {
            for idx in indices {
                let delta = list[idx]
                
                let (wraps, offset) = delta.quotientAndRemainder(dividingBy: list.count)
                var target = list.index(idx, offsetBy: offset)
                target = list.index(target, offsetBy: wraps)
                
                if delta < 0 {
                    list.moveValue(at: idx, before: target)
                } else if delta > 0 {
                    list.moveValue(at: idx, after: target)
                } else {
                    // do nothing
                }
            }
        }
        
        let zero = list.nextIndex(startingAt: nil, searchDirection: .forward, matching: { $0 == 0 })!
        let oneK = list.index(zero, offsetBy: 1000)
        let twoK = list.index(zero, offsetBy: 2000)
        let threeK = list.index(zero, offsetBy: 3000)
        
        let coords = [oneK, twoK, threeK]
        let bits = coords.map { list[$0] }
        print(bits)
        
        let p1 = bits.sum
        
        return p1
    }

    func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

}
