//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/15/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day16: Day {
    
    @objc init() { super.init(inputFile: #file) }
    
    lazy var sues: Array<Dictionary<String, Int>> = {
        let r = Regex(pattern: "Sue (\\d+): (.+)")
        let attrs = Regex(pattern: "([a-z]+): (\\d+)")
        return input.lines.raw.map { l -> Dictionary<String, Int> in
            let m = r.match(l)!
            var info = Dictionary<String, Int>()
            info["sue"] = m.int(1)!
            
            for m in attrs.matches(in: m[2]!) {
                info[m[1]!] = m.int(2)!
            }
            
            return info
        }
    }()
    
    override func part1() -> String {
        let match = [
            "children": 3,
            "cats": 7,
            "samoyeds": 2,
            "pomeranians": 3,
            "akitas": 0,
            "vizslas": 0,
            "goldfish": 5,
            "trees": 3,
            "cars": 2,
            "perfumes": 1,
        ]
        
        var sue = 0
        for s in sues {
            var matches = true
            for k in match.keys {
                if let mValue = match[k], let sValue = s[k] {
                    matches = matches && mValue == sValue
                }
            }
            if matches {
                sue = s["sue"]!
                break
            }
        }
        
        return "\(sue)"
    }
    
    override func part2() -> String {
        let match = [
            "children": 3...3,
            "cats": 8...Int.max,
            "samoyeds": 2...2,
            "pomeranians": 0...2,
            "akitas": 0...0,
            "vizslas": 0...0,
            "goldfish": 0...4,
            "trees": 4...Int.max,
            "cars": 2...2,
            "perfumes": 1...1,
        ]
        
        var sue = 0
        for s in sues {
            var matches = true
            for k in match.keys {
                if let mRange = match[k], let sValue = s[k] {
                    matches = matches && mRange.contains(sValue)
                }
            }
            if matches {
                sue = s["sue"]!
                break
            }
        }
        
        return "\(sue)"
    }
    
}
