//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2018 {

    public class Day4: Day {
        
        public init() { super.init(inputSource: .file(#file)) }
        
        lazy var shifts: Dictionary<Int, Array<Int>> = {
            // in the returned dictionary:
            // - the key is the guard id
            // - the value is a 60-element array (minutes in the hour) where the value at an array position
            //   is the number of times that guard was sleeping at that minute
            
            let regex = Regex(pattern: "\\[.+?(\\d{2})\\] (Guard #(\\d+) begins shift|falls asleep|wakes up)")
            
            var shifts = Dictionary<Int, Array<Int>>()
            
            var currentGuard = 0
            var fallsAsleep: Int?
            for line in input.lines.raw {
                let match = regex.match(line)!
                let minute = Int(match[1]!)!
                
                let event = match[2]!
                if event.hasPrefix("Guard") {
                    currentGuard = Int(match[3]!)!
                    fallsAsleep = nil
                    
                } else if event.hasPrefix("falls") {
                    fallsAsleep = minute
                } else {
                    // wakes up
                    var minutes = shifts[currentGuard] ?? Array(repeating: 0, count: 60)
                    for i in fallsAsleep! ..< minute { minutes[i] += 1 }
                    shifts[currentGuard] = minutes
                    fallsAsleep = nil
                }
            }
            
            return shifts
        }()
        
        override public func part1() -> String {
            let guardSleepTime = shifts.map { ($0, $1.sum()) }
            let mostTimeSpentSleeping = guardSleepTime.map { $0.1 }.max()!
            
            // find the guardID of the guard who sleeps the most
            let guardID = guardSleepTime.first { $1 == mostTimeSpentSleeping }!.0
            
            // get the guards time histogram
            let minutesAsleep  = shifts[guardID]!
            
            // find the most number of times he's sleeping
            let maxTimeAsleep = minutesAsleep.max()!
            
            // find what minute that is
            let minute = minutesAsleep.index(of: maxTimeAsleep)!
            
            return "\(guardID * minute)"
        }
        
        override public func part2() -> String {
            
            var maxTimesAsleepSoFar = 0
            var resultSoFar = 0
            
            for (guardID, minutes) in shifts {
                let mostTimesAsleep = minutes.max()!
                guard mostTimesAsleep > maxTimesAsleepSoFar else { continue }
                let minute = minutes.index(of: mostTimesAsleep)!
                resultSoFar = guardID * minute
                maxTimesAsleepSoFar = mostTimesAsleep
            }
            
            return "\(resultSoFar)"
        }
        
    }

}
