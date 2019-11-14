//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/16/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day17: Day {

    let integer = 314
    
    @objc init() { super.init() }

    override func part1() -> String {
        var buffer = [0]

        var position = 0
        for i in 1 ... 2017 {
            position = ((position + integer) % buffer.count) + 1
            buffer.insert(i, at: position)
        }

        return "\(buffer[position + 1])"
    }

    override func part2() -> String {
        var position = 0
        var latest = 0

        for i in 1 ... 50_000_000 {
            position = ((position + integer) % i) + 1
            if position == 1 { latest = i }
        }

        return "\(latest)"
    }
}
