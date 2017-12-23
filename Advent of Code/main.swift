//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

let durationFormatter = NumberFormatter()
durationFormatter.format = "0.00"

func execute(_ day: Day) -> TimeInterval {
    print("============ \(type(of: day)) ============")
    let start = Date()
    day.run()
    let duration = Date().timeIntervalSince(start)
    print("time: \(durationFormatter.string(from: duration as NSNumber) ?? "0.0")s")
    print("\n")
    return duration
}

let days: Array<Day> = [
//    Day1(),
//    Day2(),
//    Day3(),
//    Day4(),
//    Day5(),
//    Day6(),
//    Day7(),
//    Day8(),
//    Day9(),
//    Day10(),
//    Day11(),
//    Day12(),
//    Day13(),
//    Day14(),
//    Day15(),
//    Day16(),
//    Day17(),
//    Day18(),
//    Day19(),
//    Day20(),
//    Day21(),
    Day22(),
    Day23(),
    Day24(),
    Day25()
]

let durations = days.map(execute)
let total = durations.reduce(0.0, +)

print("TOTAL TIME: \(durationFormatter.string(from: total as NSNumber) ?? "0.0")s")
