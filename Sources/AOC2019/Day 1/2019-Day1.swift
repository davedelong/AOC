//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

private func fuel(for mass: Int) -> Int {
    return (mass / 3) - 2
}

private func allFuel(for mass: Int) -> Array<Int> {
    return Array(sequence(first: fuel(for: mass)) { m in
        let v = fuel(for: m)
        return v > 0 ? v : nil
    })
}

class Day1: Day {
    
    func run() async throws -> (String, String) {
        let modules = input().lines.integers
        
        let fuels = modules.map { allFuel(for: $0) }
        
        let p1 = fuels.compactMap(\.first).sum
        let p2 = fuels.map(\.sum).sum
        return ("\(p1)", "\(p2)")
    }
}
