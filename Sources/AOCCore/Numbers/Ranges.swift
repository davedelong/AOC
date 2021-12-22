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
    
    public var asClosedRange: ClosedRange<Bound> {
        let u = self.upperBound.advanced(by: -1)
        return self.lowerBound ... u
    }
}

extension ClosedRange {
    
    public func overlap(with other: Self) -> Self? {
        let left = self.lowerBound < other.lowerBound ? self : other
        let right = (left == self) ? other : self
        
        if left.lowerBound < right.lowerBound {
            if left.upperBound < right.lowerBound { return nil }
            if left.upperBound == right.lowerBound { return right.lowerBound ... right.lowerBound }
            if left.upperBound <= right.upperBound { return right.lowerBound ... left.upperBound }
            /* if left.upperBound > right.upperBound { */ return right
        } else {
            assert(left.lowerBound == right.lowerBound)
            return left.lowerBound ... Swift.min(left.upperBound, right.upperBound)
        }
    }
    
}

extension ClosedRange where Bound: Strideable {
    
    public init(extreme: Bound, length: Bound.Stride) {
        let e1 = extreme
        let e2 = extreme.advanced(by: length)
        
        let lower = Swift.min(e1, e2)
        let upper = Swift.max(e1, e2)
        self = lower ... upper.advanced(by: -1)
    }
    
}
