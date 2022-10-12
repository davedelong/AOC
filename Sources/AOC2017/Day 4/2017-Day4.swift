//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day4: Day {
    
    func part1() async throws -> Int {
        let answer = input().lines.words.raw.filter { $0.count == Set($0).count }.count
        return answer
    }
    
    func part2() async throws -> Int {
        
        func isValid(_ phrase: Array<String>) -> Bool {
            let countedSets = phrase.map({ $0.map { String($0) } }).map { NSCountedSet(array: $0) }
            return countedSets.count == Set(countedSets).count
        }
        
        let answer = input().lines.words.raw.filter(isValid).count
        return answer
    }
    
}
