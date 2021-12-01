//
//  Day2.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day2: Day {
    let r: Regex = #"(\d+)-(\d+) (.): (.+)"#

    override func run() -> (String, String) {
        let lines = input.rawLines.map { r.firstMatch(in: $0)! }
        
        var p1 = 0
        var p2 = 0
        
        lines.forEach { match in
            let l = match[int: 1]!
            let u = match[int: 2]!
            let c = match[char: 3]!
            let pw = match[array: 4]!
            
            let cCount = pw.count(of: c)
            if l <= cCount && cCount <= u { p1 += 1 }
            
            if (pw[l-1] == c || pw[u-1] == c) && pw[l-1] != pw[u-1] { p2 += 1 }
        }
        
        return ("\(p1)", "\(p2)")
    }
}
