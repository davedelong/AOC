//
//  Day2.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

public class Day2: Day {
    
    lazy var integers: Array<Array<Int>> = {
        return input.lines.words.integers
    }()
    
    public init() { super.init(inputSource: .file(#file)) }
    
    override public func part1() -> String {
        let answer = integers.map { $0.max()! - $0.min()! }.sum()
        return "\(answer)"
    }
    
    override public func part2() -> String {
        let answer = integers.map { row -> Int in
            row.map { item in
                let divisions = row.map { Double($0) / Double(item) }
                let multiples = divisions.filter { ceil($0) == $0 && $0 != 1 }
                return multiples.first.map { Int($0) } ?? 0
            }.sum()
        }.sum()
        return "\(answer)"
    }
    
}

}
