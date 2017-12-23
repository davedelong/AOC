//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/16/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

class Day17: Day {

    let input = 314
    
    required init() { }

    func part1() {
        var buffer = [0]

        var position = 0
        for i in 1 ... 2017 {
            position = ((position + input) % buffer.count) + 1
            buffer.insert(i, at: position)
        }

        print(buffer[position + 1])
    }

    func part2() {
        var position = 0
        var latest = 0

        for i in 1 ... 50_000_000 {
            position = ((position + input) % i) + 1
            if position == 1 { latest = i }
        }

        print(latest)
    }
}
