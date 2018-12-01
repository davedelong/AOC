//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

class Day4: Day {
    
    init() { super.init() }
    
    lazy var input: Array<Array<String>> = {
        return trimmedInputLines.map { $0.components(separatedBy: .whitespaces) }.filter { !$0.isEmpty }
    }()
    
    override func part1() -> String {
        let answer = input.filter { $0.count == Set($0).count }.count
        return "\(answer)"
    }
    
    override func part2() -> String {
        
        func isValid(_ phrase: Array<String>) -> Bool {
            let countedSets = phrase.map({ $0.map { String($0) } }).map { NSCountedSet(array: $0) }
            return countedSets.count == Set(countedSets).count
        }
        
        let answer = input.filter(isValid).count
        return "\(answer)"
    }
    
}

}
