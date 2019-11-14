//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/9/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

extension Year2015 {

    public class Day10: Day {
        
        public init() { super.init(inputSource: .raw("1321131112")) }
        
        override public func run() -> (String, String) {
            var p1 = ""
            
            var data = input.characters
            
            for i in 1 ... 50 {
                let subSequences = data.consecutivelyEqualSubsequences()
                data = subSequences.flatMap { s -> Array<Character> in
                    return Array("\(s.count)\(s.first!)")
                }
                
                if i == 40 { p1 = "\(data.count)" }
            }
            let p2 = "\(data.count)"
            return (p1, p2)
        }
        
    }

}
