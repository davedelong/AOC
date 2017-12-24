//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

class Day4: Day {
    
    required init() { }
    
    let input = Day4.inputLines().map { $0.components(separatedBy: .whitespaces) }.filter { !$0.isEmpty }
    
    func part1() -> String {
        let answer = input.filter { $0.count == Set($0).count }.count
        return "\(answer)"
    }
    
    func part2() -> String {
        
        func isValid(_ phrase: Array<String>) -> Bool {
            let countedSets = phrase.map({ $0.map { String($0) } }).map { NSCountedSet(array: $0) }
            return countedSets.count == Set(countedSets).count
        }
        
        let answer = input.filter(isValid).count
        return "\(answer)"
    }
    
}
