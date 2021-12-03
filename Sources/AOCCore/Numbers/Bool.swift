//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/10/20.
//

import Foundation

public typealias Bit = Bool

extension Bool {
    public static var on: Bool { true }
    public static var off: Bool { false }
    
    public var negated: Bool { !self }
    public var not: Bool { !self }
    
    public func toggled() -> Bool { negated }
    
    public init(_ character: Character) {
        self = trueBitChars.contains(character)
    }
}

private let trueBitChars = Set("1Tt+y")
