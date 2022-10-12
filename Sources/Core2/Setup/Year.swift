//
//  File.swift
//  
//
//  Created by Dave DeLong on 10/12/22.
//

import Foundation

public protocol Year {
    
    var days: Array<any Day> { get }
    
}

extension Year {
    
    public func today() -> any Day {
        let c = Calendar(identifier: .gregorian)
        let dc = c.dateComponents([.month, .day], from: Date())
        guard dc.month == 12 else { return InvalidDay(number: 0) }
        guard let day = dc.day else { return InvalidDay(number: 0) }
        return self.day(day)
    }
    
    public func day(_ number: Int) -> any Day {
        let idx = number - 1
        guard days.indices.contains(idx) else { return InvalidDay(number: number) }
        return days[idx]
    }
    
}

private struct InvalidDay: Day {
    let number: Int
}
