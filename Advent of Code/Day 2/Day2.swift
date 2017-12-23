//
//  Day2.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

class Day2: Day {
    
    let input: Array<Array<Int>>
    
    required init() {
        input = Day2.inputLines().map { $0.components(separatedBy: .whitespaces).flatMap { Int($0) } }
    }
    
    func part1() {
        let answer = input.map { $0.max()! - $0.min()! }.reduce(0, +)
        print(answer)
    }
    
    func part2() {
        let answer = input.map { row in
            row.map { item in
                let divisions = row.map { Double($0) / Double(item) }
                let multiples = divisions.filter { ceil($0) == $0 && $0 != 1 }
                return multiples.first.map { Int($0) } ?? 0
                }.reduce(0, +)
            }.reduce(0, +)
        print(answer)
    }
    
}
