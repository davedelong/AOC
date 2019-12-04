//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

extension Int {
    
    var digits: Array<Int> {
        var d = Array<Int>()
        var remainder = self
        while remainder > 0 {
            let m = remainder % 10
            d.append(m)
            remainder /= 10
        }
        return Array(d.reversed())
    }
    
}

class Day4: Day {
    
    let range = 167487 ... 673251
    
    override func part1() -> String {
        
        func matches(_ password: Int) -> Bool {
            let d = password.digits
            guard d.count == 6 else { return false }
            let pairs = d.consecutivePairs()
            let adjacentEqualPairs = pairs.filter({ $0.0 == $0.1 })
            guard adjacentEqualPairs.isEmpty == false else { return false }
            
            let notInAscendingOrder = pairs.filter({ $0.0 > $0.1 })
            guard notInAscendingOrder.isEmpty else { return false }
            
            return true
        }
        
        let count = range.count(where: { matches($0) })
        return "\(count)"
    }
    
    override func part2() -> String {
        
        func matches(_ password: Int) -> Bool {
            let d = password.digits
            guard d.count == 6 else { return false }
            let pairs = d.consecutivePairs()
            let adjacentEqualPairs = pairs.filter({ $0.0 == $0.1 })
            guard adjacentEqualPairs.isEmpty == false else { return false }
            
            let notInAscendingOrder = pairs.filter({ $0.0 > $0.1 })
            guard notInAscendingOrder.isEmpty else { return false }
            
            let counts = CountedSet<Int>(counting: d)
            guard counts.values.contains(2) else { return false }
            
            return true
        }
        
        let count = range.count(where: { matches($0) })
        return "\(count)"
    }
    
}
