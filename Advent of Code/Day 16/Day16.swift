//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/15/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation


let rawDay16Input = try! String(contentsOf: URL(fileURLWithPath: "/Users/dave/Desktop/test/test/input.txt"))
let day16Input = rawDay16Input.trimmingCharacters(in: .whitespacesAndNewlines)
let commands = day16Input.components(separatedBy: ",")

class Day16: Day {

    let start = Array("abcdefghijklmnop").map { String($0) }
    let commands = Day16.trimmedInput().components(separatedBy: ",")
    
    required init() { }

    func twist(_ input: Array<String>) -> Array<String> {
        var list = input
        for command in commands {
            let info = command.dropFirst()
            if command.first == "s" {
                let moveCount = Int(info)!
                list.insert(contentsOf: list.suffix(moveCount), at: 0)
                list.removeLast(moveCount)
            } else {
                let pair = info.components(separatedBy: "/")
                let f = Int(pair[0]) ?? list.index(of: pair[0])!
                let s = Int(pair[1]) ?? list.index(of: pair[1])!
                list.swapAt(f, s)
            }
        }
        return list
    }
    
    func part1() {
        let p1 = twist(start)
        print("Part 1: \(p1.joined())")
    }

    func part2() {
        var results = Array<String>()

        var list = start
        for _ in 0 ..< 1_000_000_000 {
            list = twist(list)
            let s = list.joined()
            if results.first == s { break }
            results.append(s)
        }
        let offset = 1_000_000_000 % results.count
        print("Part 2: \(results[offset - 1])")
    }

}
