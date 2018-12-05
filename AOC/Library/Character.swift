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
    
}
