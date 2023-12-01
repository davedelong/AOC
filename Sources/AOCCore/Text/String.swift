//
//  String.swift
//  AOC
//
//  Created by Dave DeLong on 12/9/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public extension String {
    
    init(repeating string: String, count: Int) {
        self = Array(repeating: string, count: count).joined()
    }
    
    func locate(_ substring: String) -> Array<Range<String.Index>> {
        
        var indices = Array<Range<String.Index>>()
        
        var r = startIndex ..< endIndex
        while let i = range(of: substring, options: [], range: r, locale: nil) {
            indices.append(i)
            r = i.upperBound ..< endIndex
        }
        return indices
    }
    
    func prefix(upTo character: Character) -> String? {
        guard let idx = self.firstIndex(of: character) else {
            return nil
        }
        return String(self[..<idx])
    }
    
    func suffix(after character: Character) -> String? {
        guard let idx = self.lastIndex(of: character) else {
            return nil
        }
        let after = self.index(after: idx)
        return String(self[after...])
    }
    
    func trimmed() -> String {
        String(self.trimming(while: \.isWhitespaceOrNewline))
    }
    
    subscript(offset count: Int) -> Character {
        let idx = self.index(self.startIndex, offsetBy: count)
        return self[idx]
    }
    
}

public extension StringProtocol {
    
    var int: Int? { Int(self) }
    
    func padding(toLength length: Int, with pad: String) -> String {
        let myLength = self.count
        let missingLength = length - myLength
        if missingLength <= 0 { return String(self) }
        
        let repetitions = Int(ceil(Double(missingLength) / Double(pad.count)))
        
        var padding = String(repeating: pad, count: repetitions)
        let extra = padding.count - missingLength
        if extra > 0 {
            padding.removeLast(extra)
        }
        
        return String(self) + padding
    }
    
}
