//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

import CommonCrypto

class Day4: Day {
    
    @objc override init() { super.init(rawInput: "ckczppom") }
    
    override func part1() -> String {
        var int = 1
        var buffer = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        while true {
            let s = "\(input.raw)\(int)"
            s.writeMD5(&buffer)
            if buffer[0] == 0 && buffer[1] == 0 && buffer[2] < 16 { return "\(int)" }
            int += 1
        }
        fatalError("unreachable")
    }
    
    override func part2() -> String {
        // we don't need to test 1-117946, because that happened in part 1
        // and anything that would've resulted in 6 zeroes would've satisfied part 1
        var int = 117947
        var buffer = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        while true {
            let s = "\(input.raw)\(int)"
            s.writeMD5(&buffer)
            if buffer[0] == 0 && buffer[1] == 0 && buffer[2] == 0 { return "\(int)" }
            int += 1
        }
        fatalError("unreachable")
    }
    
}
