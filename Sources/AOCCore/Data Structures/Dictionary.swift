//
//  Dictionary.swift
//  AOC
//
//  Created by Dave DeLong on 12/2/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public typealias Bucket<K: Hashable, V: Hashable> = Dictionary<K, Set<V>>

public func Bucketize<C1: Collection, C2: Collection>(_ elements: C1, in keys: (C1.Element) -> C2) -> Bucket<C2.Element, C1.Element>
    where C1.Element: Hashable, C2.Element: Hashable
{
    
    var b = Bucket<C2.Element, C1.Element>()
    
    for element in elements {
        let bucketKeys = keys(element)
        for key in bucketKeys {
            var bucketContents = b.removeValue(forKey: key) ?? Set()
            bucketContents.insert(element)
            b[key] = bucketContents
        }
    }
    
    return b
}
