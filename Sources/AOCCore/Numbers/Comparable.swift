//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/12/22.
//

import Foundation

extension Comparable {
    
    public func compare(_ other: Self) -> ComparisonResult {
        
        if self < other { return .orderedAscending }
        if self == other { return .orderedSame }
        return .orderedDescending
        
    }
    
}
