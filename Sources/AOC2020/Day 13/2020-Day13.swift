//
//  Day13.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day13: Day {

    override func run() -> (String, String) {
        return super.run()
    }

    override func part1() -> String {
        let timestamp = input.lines[0].integer!
        let buses = input.lines[1].integers
        
        var bus = 0
        var wait = Int.max
        var departure = Int.max
        
        for nextBus in buses {
            if timestamp % nextBus == 0 {
                // wait 0 minutes
                return "0"
            } else {
                let d = nextBus * ((timestamp+nextBus)/nextBus)
                let waitForBus = d - timestamp
                
                if d < departure {
                    departure = d
                    wait = waitForBus
                    bus = nextBus
                }
            }
        }
        
        
        return "\(bus * wait)"
    }

    override func part2() -> String {
        return #function
    }

}
