//
//  Day25.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day25: Day {
    
    static var rawInput: String? { "17773298\n15530095" }

    func part1() async throws -> String {
//        let input = Input("5764801\n17807724")
        
        let pk1 = input().integers[0]
        let pk2 = input().integers[1]
        
        var loop1: Int?
        var loop2: Int?
        
        var loopSizes = Dictionary<Int, Int>()
        var i = 1
        for loop in 1 ..< Int.max {
            i = (i * 7) % 20201227
            loopSizes[loop] = i
            
            if i == pk1 {
                loop1 = loop
            }
            if i == pk2 {
                loop2 = loop
            }
            if loop1 != nil && loop2 != nil { break }
        }
        
        let encryptionKey = transform(subject: pk1, loop: loop2!)
        
        return "\(encryptionKey)"
    }

    func transform(subject: Int = 7, loop: Int) -> Int {
        var i = 1
        for _ in 0 ..< loop {
            i = (i * subject) % 20201227
        }
        return i
    }
    
    func part2() async throws -> String {
        return ""
    }
}
