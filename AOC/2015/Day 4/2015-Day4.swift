//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

extension Year2015 {
    
    public class Day4: Day {
        
        public init() { super.init(inputSource: .raw("ckczppom")) }
        
        
        override public func part1() -> String {
            var int = 1
            while true {
                let s = "\(input.raw)\(int)"
                let d = s.md5()
                if d[0] == 0 && d[1] == 0 && d[2] < 16 { return "\(int)" }
                int += 1
            }
            fatalError("unreachable")
        }
        
        override public func part2() -> String {
            // we don't need to test 1-117946, because that happened in part 1
            // and anything that would've resulted in 6 zeroes would've satisfied part 1
            var int = 117947
            while true {
                let s = "\(input.raw)\(int)"
                let d = s.md5()
                if d[0] == 0 && d[1] == 0 && d[2] == 0 { return "\(int)" }
                int += 1
            }
            fatalError("unreachable")
        }
        
    }
    
}
