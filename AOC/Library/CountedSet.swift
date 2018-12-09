//
//  CountedSet.swift
//  AOC
//
//  Created by Dave DeLong on 12/2/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public typealias CountedSet<T: Hashable> = Dictionary<T, Int>

public extension Dictionary where Value == Int {
    
    public init<C: Collection>(counting: C) where C.Element == Key {
        self.init(minimumCapacity: counting.count)
        for item in counting {
            self[item, default: 0] += 1
        }
    }
    
    public func count(for item: Key) -> Int {
        return self[item, default: 0]
    }
    
    public mutating func remove(item: Key) {
        if let value = self[item] {
            if value > 1 {
                self[item] = value - 1
            } else {
                self.removeValue(forKey: item)
            }
        }
    }
    
}
