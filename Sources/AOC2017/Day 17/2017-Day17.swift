//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/16/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day17: Day {

    let integer = 314

    func part1() async throws -> String {
        var buffer = [0]

        var position = 0
        for i in 1 ... 2017 {
            position = ((position + integer) % buffer.count) + 1
            buffer.insert(i, at: position)
        }

        return "\(buffer[position + 1])"
    }

    func part2() async throws -> String {
        var position = 0
        var latest = 0

        for i in 1 ... 50_000_000 {
            position = ((position + integer) % i) + 1
            if position == 1 { latest = i }
        }

        return "\(latest)"
    }
}
