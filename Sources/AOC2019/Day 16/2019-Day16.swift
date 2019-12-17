//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/15/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day16: Day {
    
    private func patternValue(at index: Int, iteration: Int) -> Int {
        let p = [0, 1, 0, -1]
        let repeatSize = (p.count * iteration)
        let repeatedIndex = (index + 1) % repeatSize
        let realIndex = repeatedIndex / iteration
        return p[realIndex]
    }
    
    func runPhase(_ input: Array<Int>, offsetDelta: Int = 0, output: inout Array<Int>) {
        let loopCount = input.count
        if offsetDelta > (input.count / 2) {
            var s = input.sum()
            for i in 0 ..< loopCount {
                output[i] = Int(s.onesDigit)
                s -= input[i]
            }
        } else {
            for loop in 0 ..< loopCount {
                let sum = input.enumerated().sum { patternValue(at: $0.offset + offsetDelta, iteration: loop + 1) * $0.element }
                output[loop] = Int(sum.onesDigit)
            }
        }
    }
    
    override func part1() -> String {
        var n = input.characters.map { Int("\($0)")! }
        var o = Array(repeating: 0, count: n.count)
        for _ in 1 ... 100 {
            runPhase(n, output: &o)
            swap(&n, &o)
        }
        let firstEight = n[0..<8].map { "\($0)" }.joined()
        return firstEight
    }
    
    override func part2() -> String {
        let initial = input.characters.map { Int("\($0)")! }
        let offset = Int(digits: initial[0..<7])
        
        var n = Array<Int>()
        for _ in 0 ..< 10_000 { n.append(contentsOf: initial) }
        n.removeFirst(offset)
        
        var o = Array(repeating: 0, count: n.count)
        for _ in 1 ... 100 {
            runPhase(n, offsetDelta: offset, output: &o)
            swap(&n, &o)
        }
        
        let code = n[0 ..< 8]
        let string = code.map { "\($0)" }.joined()
        
        return string
    }
    
}
