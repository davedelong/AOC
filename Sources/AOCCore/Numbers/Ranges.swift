//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/4/20.
//

import Foundation

// these are extensions to make `Range` have the same-ish API as NSRange
extension Range where Bound: Strideable {
    
    public var length: Bound.Stride {
        get { lowerBound.distance(to: upperBound) }
        set {
            self = lowerBound ..< lowerBound.advanced(by: newValue)
        }
    }
    
    public var location: Bound {
        get { lowerBound }
        set { self = newValue ..< newValue.advanced(by: length) }
    }
    
}
