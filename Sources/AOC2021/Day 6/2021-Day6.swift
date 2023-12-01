//
//  Day6.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day6: Day {

    func part1() async throws -> Int {
        return countFish(80)
    }

    func part2() async throws -> Int {
        return countFish(256)
    }
    
    func countFish(_ days: Int) -> Int {
        var fish = CountedSet(input().integers)
        
        for _ in 0 ..< days {
            var newFish = CountedSet<Int>()
            for day in fish {
                let count = fish.count(for: day)
                var daysLeft = day-1
                if daysLeft < 0 {
                    daysLeft = 6
                    newFish.insert(8, times: count)
                }
                newFish.insert(daysLeft, times: count)
            }
            fish = newFish
        }
        
        return fish.count
    }

}
