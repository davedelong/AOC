//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/8/17.
//  Copyright © 2016 Dave DeLong. All rights reserved.
//

class Day9: Day {
    
    func part1() async throws -> Int {
        var final = Array<Character>()
        var scanner = Scanner(data: input().characters)
        
        while scanner.isAtEnd == false {
            let regular = scanner.scanUpTo("(")
            final.append(contentsOf: regular)
            
            if scanner.tryScan("(") {
                let digits = scanner.scanInt()!
                scanner.scan("x")
                let repetitions = scanner.scanInt()!
                scanner.scan(")")
                
                let sequence = scanner.scan(count: digits)
                for _ in 0 ..< repetitions { final.append(contentsOf: sequence) }
            }
        }
        
        return final.count
    }
    
    indirect enum Expansion {
        case raw(Int)
        case repeated([Expansion], Int)
        
        var totalLength: Int {
            switch self {
                case .raw(let count): return count
                case .repeated(let inners, let count): return inners.map(\.totalLength).sum * count
            }
        }
    }
    
    func part2() async throws -> Int {
        let roots = parse(input().raw)
        return roots.map(\.totalLength).sum
    }

    private func parse<S: StringProtocol>(_ string: S) -> [Expansion] {
        var s = Scanner(data: string)
        
        var final = Array<Expansion>()
        while s.isAtEnd == false {
            let regular = s.scanUpTo("(")
            if regular.isNotEmpty { final.append(.raw(regular.count)) }
            
            if s.tryScan("(") {
                let length = s.scanInt()!
                s.scan("x")
                let repetitions = s.scanInt()!
                s.scan(")")
                
                let next = s.scan(count: length)
                let inners = parse(next)
                final.append(.repeated(inners, repetitions))
            }
        }
        
        return final
    }
}
