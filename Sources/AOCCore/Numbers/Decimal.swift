//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/10/22.
//

import Foundation

extension Decimal {
    
    public var isWholeNumber: Bool {
        return self == self.round()
    }
    
    public func round(_ mode: Decimal.RoundingMode = .plain) -> Decimal {
        var copy = self
        var final = self
        NSDecimalRound(&final, &copy, 0, mode)
        return final
    }
    
    public func isDivisible(by divisor: Decimal) -> Bool {
        let quotient = self / divisor
        return quotient.isWholeNumber
    }
    
}
