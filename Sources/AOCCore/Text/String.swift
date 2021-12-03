//
//  String.swift
//  AOC
//
//  Created by Dave DeLong on 12/9/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

private let specialRegexCharacters = Set(#".[]{}()\|^$,=<>?*+!"#)

public extension String {
    
    var regexEscaped: String {
        return String(flatMap { char -> [Character] in
            if specialRegexCharacters.contains(char) {
                return [char, "\\"]
            } else {
                return [char]
            }
        })
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
        String(self.trimming(\.isWhitespaceOrNewline))
    }
    
}
