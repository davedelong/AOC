//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/3/19.
//

import Foundation

extension FixedWidthInteger {
    
    public var digits: Array<Self> {
        var d = Array<Self>()
        var remainder = self
        if remainder < 0 { remainder *= -1 }
        
        while remainder > 0 {
            let m = remainder % 10
            d.append(m)
            remainder /= 10
        }
        return Array(d.reversed())
    }
    
}
