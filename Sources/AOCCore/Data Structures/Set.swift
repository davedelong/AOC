//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/18/19.
//

import Foundation

public extension Set {
    
    static func + (lhs: Self, rhs: Self) -> Self {
        return lhs.union(rhs)
    }
    
    static func - (lhs: Self, rhs: Self) -> Self {
        return lhs.subtracting(rhs)
    }
    
    func intersects(_ other: Set<Element>) -> Bool {
        return self.intersection(other).isNotEmpty
    }
    
    func intersects<S: Sequence>(_ other: S) -> Bool where S.Element == Element {
        return self.intersection(other).isNotEmpty
    }
    
    init<C: Collection>(unioning: Array<C>) where C.Element == Element {
        self.init()
        for other in unioning {
            self.formUnion(other)
        }
    }
}

public extension Collection where Element: Collection, Element.Element: Hashable {
    
    func intersectingElements() -> Set<Element.Element> {
        guard let f = first else { return [] }
        var final = Set(f)
        dropFirst().forEach { final.formIntersection($0) }
        return final
    }
    
}
