//
//  Day2.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

class Day2: Day {
    
    var input = Array<Array<Int>>()
    
    init() {
        super.init()
        input = trimmedInputLines.map { $0.components(separatedBy: .whitespaces).compactMap { Int($0) } }
    }
    
    override func part1() -> String {
        let answer = input.map { $0.max()! - $0.min()! }.reduce(0, +)
        return "\(answer)"
    }
    
    override func part2() -> String {
        let answer = input.map { row in
            row.map { item in
                let divisions = row.map { Double($0) / Double(item) }
                let multiples = divisions.filter { ceil($0) == $0 && $0 != 1 }
                return multiples.first.map { Int($0) } ?? 0
                }.reduce(0, +)
            }.reduce(0, +)
        return "\(answer)"
    }
    
}

}
