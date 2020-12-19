//
//  Day19.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day19: Day {
    
    enum Rule {
        case literal(Character)
        case sequence([Int])
        case either([Int], [Int])
    }
    
    lazy var rawRules: Dictionary<Int, Rule> = {
        let l: Regex = #""(.)""#
        let o: Regex = #"(\d+)"#
        let s: Regex = #"(\d+) (\d+)"#
        let e1: Regex = #"(\d+) \| (\d+)"#
        let e2: Regex = #"(\d+) (\d+) \| (\d+) (\d+)"#
        
        var rawRules = Dictionary<Int, Rule>()
        for line in input.rawLines {
            if line.isEmpty { break }
            let number = line.prefix(upTo: ":")!
            let int = Int(number)!
            let remainder = line.suffix(after: ":")!.trimmed()
            
            let rule: Rule
            if let m = e2.match(remainder) {
                rule = .either([m[int: 1]!, m[int: 2]!],
                               [m[int: 3]!, m[int: 4]!])
            } else if let m = e1.match(remainder) {
                rule = .either([m[int: 1]!],
                               [m[int: 2]!])
            } else if let m = s.match(remainder) {
                rule = .sequence([m[int: 1]!, m[int: 2]!])
            } else if let m = o.match(remainder) {
                rule = .sequence([m[int: 1]!])
            } else if let m = l.match(remainder) {
                rule = .literal(m[char: 1]!)
            } else {
                fatalError()
            }
            rawRules[int] = rule
        }
        return rawRules
    }()
    
    func buildRegexPattern(_ rule: Int, part2: Bool) -> String {
        if rule == 8 && part2 == true {
            return buildRegexPattern(42, part2: part2) + "+"
        }
        
        if rule == 11 && part2 == true  {
            let _42 = buildRegexPattern(42, part2: part2)
            let _31 = buildRegexPattern(31, part2: part2)
            
            var possibilities = Array<String>()
            // assume that nothing will match this more than 5 times
            for count in 1 ... 5 {
                let lR = Array(repeating: _42, count: count).joined()
                let rR = Array(repeating: _31, count: count).joined()
                possibilities.append(lR + rR)
            }
            let options = possibilities.joined(separator: "|")
            return "(\(options))"
        }
        
        guard let r = rawRules[rule] else { return "" }
        switch r {
            case .literal(let c): return "\(c)"
            case .sequence(let rules):
                return rules.map { buildRegexPattern($0, part2: part2) }.joined()
            case .either(let a, let b):
                let aP = a.map { buildRegexPattern($0, part2: part2) }.joined()
                let bP = b.map { buildRegexPattern($0, part2: part2) }.joined()
                return "(\(aP)|\(bP))"
        }
    }

    override func part1() -> String {
        let r = "^" + self.buildRegexPattern(0, part2: false) + "$"
        let regex = Regex(pattern: r)
        let inputs = input.raw.split(on: "\n\n")[1].split(on: "\n")
        
        let count = inputs.count(where: { regex.matches($0) })
        return "\(count)"
    }

    override func part2() -> String {
        rawRules[8] = .either([42], [42, 8])
        rawRules[11] = .either([42, 31], [42, 11, 31])
        
        let r = "^" + self.buildRegexPattern(0, part2: true) + "$"
        let regex = Regex(pattern: r)
        let inputs = input.raw.split(on: "\n\n")[1].split(on: "\n")
        
        let count = inputs.count(where: { regex.matches($0) })
        return "\(count)"
    }

}
