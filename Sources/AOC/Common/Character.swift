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
    
    var uppercased: Character {
        return "\(self)".uppercased().first!
    }
    
    var lowercased: Character {
        return "\(self)".lowercased().first!
    }
    
    var isDigit: Bool {
        switch self {
            case "0"..."9": return true
            default: return false
        }
    }
    
    var isHexDigit: Bool {
        switch self {
            case "a"..."f": return true
            case "A"..."F": return true
            default: return isDigit
        }
    }
    
    var isUppercase: Bool {
        return uppercased == self
    }
    
}
