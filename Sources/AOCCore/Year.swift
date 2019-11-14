//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/14/19.
//

import Foundation
import ObjectiveC

open class Year: NSObject {
    
    private static func parseYear(from thisClass: AnyClass) -> Int? {
        let rawName = class_getName(thisClass)
        let suffix = String(cString: rawName).suffix(4)
        return Int(suffix)
    }
    
    private static let years: Dictionary<Int, () -> Year?> = {
        var y = Dictionary<Int, () -> Year?>()
        
        var count: UInt32 = 0
        var classes = objc_copyClassList(&count)
        for i in 0 ..< Int(count) {
            guard let thisClass = classes?[i] else { continue }
            guard class_getSuperclass(thisClass) == Year.self else {
                if class_getSuperclass(thisClass) == Day.self {
                    let rawName = class_getName(thisClass)
                    print("Found day: \(String(cString: rawName))")
                }
                continue
            }
            guard let year = parseYear(from: thisClass) else { continue }
            y[year] = { (thisClass as! NSObject.Type).init() as? Year }
        }
        
        return y
    }()
    
    public static func `for`(_ number: Int) -> Year? { return years[number]?() }
    
    public let days: Array<Day>
    public let year: Int
    
    public init(days: Array<Day>) {
        self.year = Year.parseYear(from: type(of: self))!
        self.days = days
        super.init()
    }
    
    public override convenience init() {
        self.init(days: [])
    }
    
    public func day(_ number: Int) -> Day {
        return days[number - 1]
    }
    
}
