//
//  Character.swift
//  AOC
//
//  Created by Dave DeLong on 12/4/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public extension Character {
    
    public static let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
    
    public var uppercased: Character {
        return "\(self)".uppercased().first!
    }
    
    public var lowercased: Character {
        return "\(self)".lowercased().first!
    }
    
    public var isDigit: Bool {
        switch self {
            case "0"..."9": return true
            default: return false
        }
    }
    
    public var isHexDigit: Bool {
        switch self {
            case "a"..."f": return true
            case "A"..."F": return true
            default: return isDigit
        }
    }
    
    public var isUppercase: Bool {
        return uppercased == self
    }
    
}
