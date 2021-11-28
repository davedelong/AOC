//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/14/19.
//

import Foundation
import ObjectiveC

public class Year {

    private let year: Int
    
    public init(_ year: Int) {
        self.year = year
    }
    
    public func day(_ day: Int) -> Day {
        guard let dayClass = objc_getClass("AOC\(year).Day\(day)") else {
            return Bad()
        }
        guard let dayType = dayClass as? NSObject.Type else {
            return Bad()
        }
        
        guard let instance = class_createInstance(dayType, 0) else {
            return Bad()
        }
        
        guard let day = instance as? Day else {
            return Bad()
        }
        
        return day
    }
    
    public func allDays() -> Array<Day> {
        return (1...25).map { day($0) }
    }
    
}
