//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/15/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day16: Day {

    let start = Array("abcdefghijklmnop").map { String($0) }
    lazy var commands: Array<String> = {
        return input().raw.components(separatedBy: ",")
    }()

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
                let f = Int(pair[0]) ?? list.firstIndex(of: pair[0])!
                let s = Int(pair[1]) ?? list.firstIndex(of: pair[1])!
                list.swapAt(f, s)
            }
        }
        return list
    }
    
    func part1() async throws -> String {
        let p1 = twist(start)
        return p1.joined()
    }

    func part2() async throws -> String {
        var results = Array<String>()

        var list = start
        for _ in 0 ..< 1_000_000_000 {
            list = twist(list)
            let s = list.joined()
            if results.first == s { break }
            results.append(s)
        }
        let offset = 1_000_000_000 % results.count
        return "\(results[offset - 1])"
    }

}
