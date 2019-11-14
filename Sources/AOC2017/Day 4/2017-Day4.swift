//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day4: Day {
    
    @objc init() { super.init(inputFile: #file) }
    
    override func part1() -> String {
        let answer = input.rawLineWords.filter { $0.count == Set($0).count }.count
        return "\(answer)"
    }
    
    override func part2() -> String {
        
        func isValid(_ phrase: Array<String>) -> Bool {
            let countedSets = phrase.map({ $0.map { String($0) } }).map { NSCountedSet(array: $0) }
            return countedSets.count == Set(countedSets).count
        }
        
        let answer = input.rawLineWords.filter(isValid).count
        return "\(answer)"
    }
    
}
