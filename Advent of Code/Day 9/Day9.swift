//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/8/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

class Day9: Day {
    required init() { }

    func run() {
        let input = Day9.trimmedInput()
        var pt1 = 0
        var pt2 = 0

        var depth = 0
        var bad = false
        var ignore = false

        for c in input {
            if ignore { ignore = false; continue }
            ignore = c == "!"
        
            if bad {
                bad = c != ">"
                pt2 += (bad && !ignore) ? 1 : 0
            } else if c == "<" {
                bad = true
            } else if c == "{" {
                depth += 1
            } else if c == "}" {
                pt1 += depth; depth -= 1
            }
        }

        print(pt1)
        print(pt2)
    }
}
