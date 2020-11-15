//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/13/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day14: Day {
    
    private
    
    struct Reaction {
        let inputs: Dictionary<String, Int>
        let output: (Int, String)
    }
    
    private func parse(_ inputLines: Array<String>) -> Dictionary<String, Reaction> {
        let regex = Regex(pattern: #"(\d+) ([A-Z]+)"#)
        var reactions = Dictionary<String, Reaction>()
        
        for line in inputLines {
            let parts = line.components(separatedBy: "=>")
            
            let inputMatches = regex.matches(in: parts[0])
            let output = regex.match(parts[1])!
            
            var inputs = Dictionary<String, Int>()
            for match in inputMatches {
                inputs[match[2]!] = match.int(1)!
            }
            let rOutput = (output.int(1)!, output[2]!)
            
            let r = Reaction(inputs: inputs, output: rOutput)
            reactions[rOutput.1] = r
        }
        return reactions
    }
    
    private func attempt2(_ inputLines: Array<String>) -> Int {
        var needed = ["FUEL": 1]
        
        while needed.keys.any(satisfy: { $0 != "ORE" }) {
            
        }
        
        
        
        return needed["ORE"]!
    }
    
    private func oreNeeded(for inputLines: Array<String>) -> Int {
        let reactions = parse(inputLines)
        
        var nodesToProcess = [(1, "FUEL")]
        var initialAmounts = Dictionary<String, Int>()
        
        while nodesToProcess.isNotEmpty {
            let (amount, kind) = nodesToProcess.removeFirst()
            
            let reactionToProduceThis = reactions[kind]!
            let numberOfReactionsNeeded = Int(ceil(Double(amount) / Double(reactionToProduceThis.output.0)))
            
            for (inputName, inputAmount) in reactionToProduceThis.inputs {
                if inputName == "ORE" {
                    initialAmounts[kind, default: 0] += amount
                } else {
                    let totalInputAmount = inputAmount * numberOfReactionsNeeded
                    nodesToProcess.append((totalInputAmount, inputName))
                }
            }
        }
        
        var oreCount = 0
        for (kind, amount) in initialAmounts {
            let r = reactions[kind]!
            let numberOfReactionsNeeded = Int(ceil(Double(amount) / Double(r.output.0)))
            let amountOfOreNeeded = r.inputs["ORE"]! * numberOfReactionsNeeded
            oreCount += amountOfOreNeeded
        }
        
        print(initialAmounts)
        return oreCount
    }
    
    func testCases() {
        let tests = [
            """
10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL
""": 31,
        """
9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL
""" : 165,
        """
        157 ORE => 5 NZVS
        165 ORE => 6 DCFZ
        44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
        12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
        179 ORE => 7 PSHF
        177 ORE => 5 HKGWZ
        7 DCFZ, 7 PSHF => 2 XJWVT
        165 ORE => 2 GPVTF
        3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
""": 13312,
        """
2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
17 NVRVD, 3 JNWZP => 8 VPVL
53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
22 VJHF, 37 MNCFX => 5 FWMGM
139 ORE => 4 NVRVD
144 ORE => 7 JNWZP
5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
145 ORE => 6 MNCFX
1 NVRVD => 8 CXFTF
1 VJHF, 6 MNCFX => 4 RFSQX
176 ORE => 6 VJHF
""": 180697,
        """
171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX
""": 2210736
        ]
        
        var i = 1
        for (input, amount) in tests {
            let lines = input.components(separatedBy: .newlines)
            let needed = oreNeeded(for: lines)
            if needed == amount {
                print("OK #\(i)")
            } else {
                print("FAILED #\(i). GOT \(needed), EXPECTED \(amount)")
            }
            i += 1
        }
    }
    
    override func run() -> (String, String) {
        testCases()
        
        let p1 = oreNeeded(for: input.lines.raw)
        return ("\(p1)", "")
    }
    
    override func part1() -> String {
        
        
        return #function
    }
    
    override func part2() -> String {
        return #function
    }
    
}
