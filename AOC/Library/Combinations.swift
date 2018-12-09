//
//  Combinations.swift
//  AOC
//
//  Created by Dave DeLong on 12/8/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public struct PermutationIterator<T>: IteratorProtocol {
    
    private var hasReturnedInitial = false
    private var a: Array<T>
    private var c: Array<Int>
    private let n: Int
    private var i = 0
    
    public init<C: Collection>(_ values: C) where C.Element == T {
        a = Array(values)
        n = a.count
        c = Array(repeating: 0, count: n)
    }
    
    public mutating func next() -> Array<T>? {
        if hasReturnedInitial == false {
            hasReturnedInitial = true
            return a
        }
        
        // this uses a non-recursive version of Heap's Algorithm
        // https://en.wikipedia.org/wiki/Heap%27s_algorithm
        while i < n {
            if c[i] < i {
                if i % 2 == 0 {
                    a.swapAt(0, i)
                } else {
                    a.swapAt(c[i], i)
                }
                c[i] += 1
                i = 0
                return a
            } else {
                c[i] = 0
                i += 1
            }
        }
        return nil
    }
}

public struct CombinationIterator<T>: IteratorProtocol {
    
    private let source: Array<T>
    private var pick: Array<Bool>
    private var done = false
    
    public init<C: Collection>(_ values: C) where C.Element == T {
        source = Array(values)
        pick = Array(repeating: false, count: source.count)
    }
    
    public mutating func next() -> Array<T>? {
        guard done == false else { return nil }
        
        let elements = zip(pick, source).compactMap { $0.0 ? nil : $0.1 }
        
        var column = 0
        var carry = true
        while carry == true && column < pick.count {
            carry = (pick[column] == true)
            pick[column].toggle()
            column += 1
        }
        // if we got to the end and still have to carry, we're done
        done = carry
        
        return elements
    }
    
}
