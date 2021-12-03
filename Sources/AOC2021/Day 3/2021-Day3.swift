//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

class Day3: Day {

    override func part1() -> String {
        let bits = input.lines.characters.map { $0.map { $0 == "1" ? true : false } }
        let totalCount = bits.count
        
        var gamma = Array<Bool>()
        var epsilon = Array<Bool>()
        for i in 0 ..< 12 {
            let onCount = bits.count(where: { $0[i] })
            let offCount = totalCount - onCount
            
            gamma.append(onCount > offCount)
            epsilon.append(onCount < offCount)
        }
        
        let g = Int(bits: gamma)
        let e = Int(bits: epsilon)
        
        return "\(g * e)"
    }

    override func part2() -> String {
        let bits = input.lines.characters.map { $0.map { $0 == "1" ? true : false } }
        
        var o2Remaining = bits
        var co2Remaining = bits
        
        for i in 0 ..< 12 {
            
            if o2Remaining.count > 1 {
                let o2On = o2Remaining.count { $0[i] }
                let o2Off = o2Remaining.count - o2On
                let o2Value = o2On >= o2Off
                o2Remaining = o2Remaining.filter { $0[i] == o2Value }
            }
            
            if co2Remaining.count > 1 {
                let co2On = co2Remaining.count { $0[i] }
                let co2Off = co2Remaining.count - co2On
                let co2Value = co2On < co2Off
                co2Remaining = co2Remaining.filter { $0[i] == co2Value }
            }
            
        }
        let o = Int(bits: o2Remaining[0])
        let c = Int(bits: co2Remaining[0])
        return "\(o * c)"
    }

}
