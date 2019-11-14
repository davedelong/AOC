//
//  Pair.swift
//  AOC
//
//  Created by Dave DeLong on 12/8/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public struct Pair<T> {
    public let first: T
    public let second: T
    
    public init(_ f: T, _ s: T) {
        first = f
        second = s
    }
}

extension Pair: Equatable where T: Equatable {
    
    public static func ==(lhs: Pair, rhs: Pair) -> Bool {
        return lhs.first == rhs.first && lhs.second == rhs.second
    }
    
}

extension Pair: Hashable where T: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(first)
        hasher.combine(second)
    }
    
}
