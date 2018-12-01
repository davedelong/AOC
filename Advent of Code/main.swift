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
        
        let (duration, part1, part2) = autoreleasepool { () -> (TimeInterval, String, String) in
            let start = Date()
            let results = self.run()
            return (Date().timeIntervalSince(start), results.0, results.1)
        }
        
        print("part 1: \(part1)")
        print("part 2: \(part2)")
        print("time: \(durationFormatter.string(from: duration as NSNumber) ?? "0.0")s")
        print("\n")
        return duration
    }
}

let focusOnDay: Int? = 1

let thisYear = Year2018()

let days = thisYear.days

if let focus = focusOnDay {
    let index = focus - 1
    _ = days[index].execute()
} else {

    let durations = days.map{ $0.execute() }
    let total = durations.reduce(0.0, +)

    print("TOTAL TIME: \(durationFormatter.string(from: total as NSNumber) ?? "0.0")s")
}
