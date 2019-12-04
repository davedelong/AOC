//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day4: Day {
    
    let range = 197487 ... 673251
    
    private func matches(_ password: Int) -> (Bool, Bool) {
        let d = password.digits
        guard d.count == 6 else { return (false, false) }
        
        let pairs = d.consecutivePairs()
        guard pairs.count(where: { $0.0 == $0.1 }) > 0 else { return (false, false) }
        guard pairs.allSatisfy({ $0.1 >= $0.0 }) else { return (false, false) }
        
        let counts = CountedSet<Int>(counting: d)
        guard counts.values.contains(2) else { return (true, false) }
        
        return (true, true)
    }
    
    override func run() -> (String, String) {
        
        var p1Count = 0
        var p2Count = 0
        
        range.forEach { p in
            let (p1, p2) = matches(p)
            p1Count += p1 ? 1 : 0
            p2Count += p2 ? 1 : 0
        }
        
        return ("\(p1Count)", "\(p2Count)")
    }
}
