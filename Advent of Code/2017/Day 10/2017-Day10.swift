//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/9/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

class Day10: Day {

    let input = "157,222,1,2,177,254,0,228,159,140,249,187,255,51,76,30"
    
    init() { super.init() }

    func twist(input: Array<Int>, lengths: Array<Int>, iterations: Int = 1) -> Array<Int> {
        var list = input
        var skip = 0
        var pos = 0

        for _ in 0 ..< iterations {
            for length in lengths {
                let sliceEnd = pos + length
                let end = min(list.count, sliceEnd)
                let wrap = (sliceEnd >= list.count) ? sliceEnd % list.count : 0
                let slice = list[pos ..< end] + list[0 ..< wrap]
                for (offset, i) in slice.reversed().enumerated() { list[(pos + offset) % list.count] = i }
                pos = (pos + length + skip) % list.count
                skip += 1
            }
        }

        return list
    }

    func hash(_ input: Array<Int>) -> String {
        let hashPieces = (0..<16).map { input[$0 * 16 ..< ($0 + 1) * 16].reduce(0, ^) }
        return hashPieces.map { String(format:"%02x", $0) }.reduce("", +)
    }

    override func part1() -> String {
        let part1Input = input.components(separatedBy: ",").map { Int($0)! }
        let part1Result = twist(input: Array(0..<256), lengths: part1Input)
        return "\(part1Result[0] * part1Result[1])"
    }

    override func part2() -> String {
        let part2Input = input.unicodeScalars.map { Int($0.value) }
        let p2Lengths = part2Input + [17, 31, 73, 47, 23]
        let result = twist(input: Array(0..<256), lengths: p2Lengths, iterations: 64)
        return hash(result)
    }

}

}
