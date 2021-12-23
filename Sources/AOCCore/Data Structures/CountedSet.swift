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
    
    init<C: Collection>(_ other: C) where C.Element == Key {
        self.init(counting: other)
    }
    
    init<C: Collection>(counting: C) where C.Element == Key {
        self.init(minimumCapacity: counting.count)
        for item in counting {
            self[item, default: 0] += 1
        }
    }
    
    func count(for item: Key) -> Int {
        return self[item, default: 0]
    }
    
    mutating func insert(item: Key, times: Int) {
        guard times > 0 else { return }
        self[item, default: 0] += times
    }
    
    mutating func remove(item: Key) {
        if let value = self[item] {
            if value > 1 {
                self[item] = value - 1
            } else {
                self.removeValue(forKey: item)
            }
        }
    }
    
    func mostCommon() -> Key? {
        return self.max(by: { $0.value <= $1.value })?.key
    }
    
    func leastCommon() -> Key? {
        return self.min(by: { $0.value <= $1.value })?.key
    }
    
    func mostCommon(preferring tieBreaker: Key) -> Key {
        guard let maxCount = self.values.max() else { return tieBreaker }
        let keys = self.filter { $0.value == maxCount }.map(\.key)
        if keys.count == 0 { return tieBreaker }
        if keys.count == 1 { return keys[0] }
        return tieBreaker
    }
    
    func leastCommon(preferring tieBreaker: Key) -> Key {
        guard let minCount = self.values.min() else { return tieBreaker }
        let keys = self.filter { $0.value == minCount }.map(\.key)
        if keys.count == 0 { return tieBreaker }
        if keys.count == 1 { return keys[0] }
        return tieBreaker
    }
    
}
