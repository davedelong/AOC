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
    
    func part2() async throws -> String {
        return #function
    }

}
