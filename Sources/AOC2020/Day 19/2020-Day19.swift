//
//  Day19.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

extension Array where Element == Int {
    init<S: StringProtocol>(integersIn string: S) {
        let matches = Regex.integers.matches(in: string)
        let ints = matches.compactMap { $0[int: 1] }
        self = ints
    }
}

class Day19: Day {
    
    enum Rule {
        case literal(Character)
        case sequence([Int])
        case either([Int], [Int])
    }
    
    lazy var rawRules: Dictionary<Int, Rule> = {
        var rawRules = Dictionary<Int, Rule>()
        for line in input.rawLines {
            if line.isEmpty { break }
            let number = line.prefix(upTo: ":")!
            let int = Int(number)!
            let remainder = line.suffix(after: ":")!.trimmed()
            
            let rule: Rule
            if remainder.hasPrefix("\"") {
                // literal
                rule = .literal(Array(remainder)[1])
            } else {
                let split = remainder.split(on: "|")
                let ints = split.map { Array(integersIn: $0) }
                if ints.count == 1 {
                    rule = .sequence(ints[0])
                } else {
                    rule = .either(ints[0], ints[1])
                }
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
