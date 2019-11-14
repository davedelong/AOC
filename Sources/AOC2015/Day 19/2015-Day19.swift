//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/18/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day19: Day {
    
    private let source = "CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF"
    
    lazy var rules: Array<(String, String)> = {
        let words = input.lines.words.raw
        var rules = Array<(String, String)>()
        for w in words {
            rules.append((w[0], w[2]))
        }
        return rules
    }()
    
    init() { super.init(inputFile: #file) }
    
    override func part1() -> String {
        var seen = Set<String>()
        
        for (find, replace) in rules {
            let indices = source.locate(find)
            for range in indices {
                let replaced = source.replacingCharacters(in: range, with: replace)
                seen.insert(replaced)
            }
        }
        
        return "\(seen.count)"
    }
    
    override func part2() -> String {
        // https://www.reddit.com/r/adventofcode/comments/3xflz8/day_19_solutions/
        
        // result = count(tokens) - count("Rn" or "Ar") - 2*count("Y") - 1
        
        let elements = source.partition(where: { $0.isUppercase }).map { String($0) }
        
        let counts = CountedSet(counting: elements)
        
        let tokenCount = elements.count
        let rnCount = counts["Rn"] ?? 0
        let arCount = counts["Ar"] ?? 0
        let yCount = counts["Y"] ?? 0
        
        let results = tokenCount - (rnCount + arCount) - (2 * yCount) - 1
        
        return "\(results)"
    }

}
