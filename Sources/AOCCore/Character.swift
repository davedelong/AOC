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
        return uppercased().first!
    }
    
    var lowercased: Character {
        return lowercased().first!
    }
    
    var isUppercase: Bool {
        return uppercased == self
    }
    
}
