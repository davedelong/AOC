//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

public class Day4: Day {
    
    public init() { super.init(inputSource: .file(#file)) }
    
    override public func part1() -> String {
        let answer = input.trimmed.rawLineWords.filter { $0.count == Set($0).count }.count
        return "\(answer)"
    }
    
    override public func part2() -> String {
        
        func isValid(_ phrase: Array<String>) -> Bool {
            let countedSets = phrase.map({ $0.map { String($0) } }).map { NSCountedSet(array: $0) }
            return countedSets.count == Set(countedSets).count
        }
        
        let answer = input.trimmed.rawLineWords.filter(isValid).count
        return "\(answer)"
    }
    
}

}
