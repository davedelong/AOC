//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

@_exported import Foundation
@_exported import GameplayKit

let durationFormatter = NumberFormatter()
durationFormatter.format = "0.00"

extension Day {
    fileprivate func execute() -> TimeInterval {
        print("============ \(type(of: self)) ============")
        
        let (duration, results) = autoreleasepool { () -> (TimeInterval, (String, String)) in
            let start = Date()
            let results = self.run()
            return (Date().timeIntervalSince(start), results)
        }
        
        
        print("part 1: \(results.0)")
        print("part 2: \(results.1)")
        print("time: \(durationFormatter.string(from: duration as NSNumber) ?? "0.0")s")
        print("\n")
        return duration
    }
}

let focusOnDay: Int? = nil//25

let thisYear = Year2017()

let days = thisYear.days

if let focus = focusOnDay {
    let index = focus - 1
    _ = days[index].execute()
} else {

    let durations = days.map{ $0.execute() }
    let total = durations.reduce(0.0, +)

    print("TOTAL TIME: \(durationFormatter.string(from: total as NSNumber) ?? "0.0")s")
}
