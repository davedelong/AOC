//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/14/19.
//

import Foundation
import ObjectiveC

open class Year: NSObject {

    public let year: Int
    
    public init(for year: Int) {
        self.year = year
        super.init()
    }
    
    public func day(_ day: Int) -> Day {
        let dayClass = objc_getClass("AOC\(year).Day\(day)")
        print("trying AOC\(year).Day\(day)")
        return (dayClass as! NSObject.Type).init() as! Day
    }
    
}
