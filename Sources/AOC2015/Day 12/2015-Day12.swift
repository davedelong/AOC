//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/11/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

import Foundation

extension Year2015 {

    public class Day12: Day {
        
        public init() { super.init(inputFile: #file) }
        
        lazy var json: Any = {
            let d = Data(input.raw.utf8)
            return try! JSONSerialization.jsonObject(with: d, options: [])
        }()
        
        private func walkJSON(_ json: Any, visitor: (Any) -> Bool) {
            let ok = visitor(json)
            if ok == false { return }
            if let a = json as? Array<Any> {
                for item in a {
                    walkJSON(item, visitor: visitor)
                }
            } else if let d = json as? Dictionary<String, Any> {
                for (key, value) in d {
                    walkJSON(key, visitor: visitor)
                    walkJSON(value, visitor: visitor)
                }
            }
        }
        
        override public func part1() -> String {
            var sum = 0
            walkJSON(json) { j in
                let n = (j as? Int) ?? 0
                sum += n
                return true
            }
            return "\(sum)"
        }
        
        override public func part2() -> String {
            var sum = 0
            walkJSON(json) { j -> Bool in
                let d = j as? Dictionary<String, Any>
                if d?.values.contains(where: { ($0 as? String) == "red" }) == true {
                    return false
                }
                
                let n = (j as? Int) ?? 0
                sum += n
                return true
            }
            return "\(sum)"
        }
        
    }

}
