//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/8/19.
//

import Foundation

public struct Sparse<Element>: Collection {
    public func index(after i: Int) -> Int { return i + 1 }
    
    public let startIndex = 0
    public var endIndex: Int { return maxIndex }
    
    private var data = Dictionary<Int, Element>()
    private let `default`: Element
    private var maxIndex: Int
    
    public var count: Int { return maxIndex + 1 }
    
    public init<C: Collection>(_ collection: C, default: Element) where C.Element == Element {
        self.default = `default`
        for (offset, element) in collection.enumerated() {
            data[offset] = element
        }
        maxIndex = collection.count - 1
    }
    
    public subscript(index: Int) -> Element {
        get {
            return data[index] ?? `default`
        }
        set {
            data[index] = newValue
            maxIndex = Swift.max(maxIndex, index)
        }
    }
    
}
