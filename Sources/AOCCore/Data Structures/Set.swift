//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/18/19.
//

import Foundation

public extension Set {
    
    func intersects(_ other: Set<Element>) -> Bool {
        return self.intersection(other).isNotEmpty
    }
    
    func intersects<S: Sequence>(_ other: S) -> Bool where S.Element == Element {
        return self.intersection(other).isNotEmpty
    }
    
}
