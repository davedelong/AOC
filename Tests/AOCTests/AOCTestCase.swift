//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/26/21.
//

import Foundation
import XCTest
import AOCCore

private let yearRegex = Regex(#"Test(\d{4})"#)
private let dayRegex = Regex(#"testDay(\d+)"#)

open class AOCTestCase: XCTestCase {
    
    var day: Day {
        guard let invocation = self.invocation else {
            fatalError("Test is not running")
        }
        
        let testClass = String(describing: type(of: self))
        guard let year = yearRegex.firstMatch(in: testClass)?[int: 1] else {
            fatalError("Cannot match year name")
        }
        
        let testSelector = NSStringFromSelector(invocation.selector)
        guard let day = dayRegex.firstMatch(in: testSelector)?[int: 1] else {
            fatalError("Cannot match day number")
        }
        
        return Day.day(for: year, month: 12, day: day)
    }
    
}
