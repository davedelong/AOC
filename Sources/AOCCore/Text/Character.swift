//
//  Character.swift
//  AOC
//
//  Created by Dave DeLong on 12/4/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public extension Character {
    
    static let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
    
    init?(ascii: Int) {
        guard let scalar = Unicode.Scalar(ascii) else { return nil }
        self.init(scalar)
    }
    
    var isWhitespaceOrNewline: Bool { isWhitespace || isNewline }
    
    var uppercased: Character {
        return uppercased().first!
    }
    
    var lowercased: Character {
        return lowercased().first!
    }
    
    var isUppercase: Bool {
        return uppercased == self
    }
    
    var alphabeticIndex: Int? {
        guard self.isASCII && self.isLetter else { return nil }
        let lower = self.lowercased
        guard let ascii = lower.asciiValue else { return nil }
        return Int(ascii - 97)
    }
    
    var alphabeticOrdinal: Int? {
        guard let index = self.alphabeticIndex else { return nil }
        return index + 1
    }
}
