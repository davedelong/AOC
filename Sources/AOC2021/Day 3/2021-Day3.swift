//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

class Day3: Day {

    override func part1() -> String {
        let bits = input.lines.bits
        
        var gamma = Array<Bool>()
        var epsilon = Array<Bool>()
        for i in 0 ..< bits[0].count {
            let stats = bits[vertical: i].countElements()
            gamma.append(stats.mostCommon(preferring: true))
            epsilon.append(stats.leastCommon(preferring: false))
        }
        
        let g = Int(bits: gamma)
        let e = Int(bits: epsilon)
        return "\(g * e)"
    }

    override func part2() -> String {
        let bits = input.lines.bits
        
        var o2Remaining = bits
        var co2Remaining = bits
        
        for i in 0 ..< bits[0].count {
            if o2Remaining.count > 1 {
                let stats = o2Remaining[vertical: i].countElements()
                let most = stats.mostCommon(preferring: true)
                o2Remaining = o2Remaining.filter { $0[i] == most }
            }
            
            if co2Remaining.count > 1 {
                let stats = co2Remaining[vertical: i].countElements()
                let least = stats.leastCommon(preferring: false)
                co2Remaining = co2Remaining.filter { $0[i] == least }
            }
            
        }
        let o = Int(bits: o2Remaining[0])
        let c = Int(bits: co2Remaining[0])
        return "\(o * c)"
    }

}
