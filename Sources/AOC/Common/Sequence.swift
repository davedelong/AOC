//
//  Sequence.swift
//  
//
//  Created by Dave DeLong on 9/24/19.
//

import Swift

public func Infinite<C: RandomAccessCollection>(_ c: C) -> UnfoldSequence<C.Element, C.Index> {
    return sequence(state: c.startIndex, next: { idx -> C.Element? in
        let e = c[idx]
        idx = c.index(after: idx)
        if idx >= c.endIndex { idx = c.startIndex }
        return e
    })
}
