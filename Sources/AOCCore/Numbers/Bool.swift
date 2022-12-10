//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/10/20.
//

import Foundation

public typealias Bit = Bool

extension Bool {
    public static var yes: Bool { true }
    public static var no: Bool { false }
    
    public static var on: Bool { true }
    public static var off: Bool { false }
    
    public var negated: Bool { !self }
    public var not: Bool { !self }
    
    public func toggled() -> Bool { negated }
    
    public init?(_ character: Character) {
        if trueBitChars.contains(character) {
            self = true
        } else if falseBitChars.contains(character) {
            self = false
        } else {
            return nil
        }
    }
    
    public var isTrue: Bool { self == true }
    public var isFalse: Bool { self == false }
}

extension Character {
    
    public var bitValue: Bit? { Bit(self) }
    
}

private let trueBitChars = Set("1Tt+Yy")
private let falseBitChars = Set("0Ff-Nn")
