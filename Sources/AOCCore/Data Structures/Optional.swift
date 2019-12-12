//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/12/19.
//

import Foundation

public protocol OptionalType {
    associatedtype Wrapped
    
    var asOptional: Optional<Wrapped> { get }
}

extension Optional: OptionalType {
    public var asOptional: Optional<Wrapped> { return self }
}

extension Collection where Element: OptionalType {
    
    public var compacted: Array<Element.Wrapped> {
        return compactMap { $0.asOptional }
    }
    
}
