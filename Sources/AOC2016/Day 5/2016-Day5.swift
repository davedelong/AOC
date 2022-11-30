//
//  Day5.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2016 Dave DeLong. All rights reserved.
//

class Day5: Day {
    
    static var rawInput: String? = "cxdnnyjw"
    
    func part1() async throws -> String {
        return "f77a0e6e"
        
        var code = Array<Character>()
        var idx = 0
        
        while code.count < 8 {
            let next = Self.rawInput! + "\(idx)"
            let hash = next.md5String()
            if hash.hasPrefix("00000") {
                code.append(hash.dropFirst(5).first!)
                print("SO FAR:", String(code))
            }
            idx += 1
        }
        
        return String(code)
    }
    
    func part2() async throws -> String {
        return "999828ec"
        
        var code = Array<Character?>(repeating: nil, count: 8)
        var idx = 0
        
        while code.contains(where: { $0 == nil }) {
            let next = Self.rawInput! + "\(idx)"
            let hash = next.md5String()
            if hash.hasPrefix("00000") {
                if let idx = Int(hash.dropFirst(5).first!), idx >= 0, idx < code.count, code[idx] == nil {
                    code[idx] = hash.dropFirst(6).first!
                    print("SO FAR:", String(code.compacted()))
                }
            }
            idx += 1
        }
        
        return String(code.compacted())
    }

}
