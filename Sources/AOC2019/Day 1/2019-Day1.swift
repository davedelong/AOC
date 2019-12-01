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

private func allFuel(for mass: Int) -> UnfoldFirstSequence<Int> {
    let f: (Int) -> Int = { ($0 / 3) - 2 }
    return sequence(first: f(mass)) { m in
        let v = fuel(for: m)
        return v > 0 ? v : nil
    }
}

class Day1: Day {
    
    override func part1() -> String {
        let modules = input.lines.integers
        let fuels = modules.map { fuel(for: $0) }
        return "\(fuels.sum())"
    }
    
    override func part2() -> String {
        let modules = input.lines.integers
        let masses = modules.map { Array(allFuel(for: $0)).sum() }
        return "\(masses.sum())"
    }
}
