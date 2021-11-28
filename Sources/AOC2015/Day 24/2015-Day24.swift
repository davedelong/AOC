//
//  Day24.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day24: Day {

    override func run() -> (String, String) {
        return ("", "")
    }
    
    override func part1() -> String {
        let weights = input.integers
        let totalWeight = weights.sum
        let groupWeight = totalWeight / 3
        
        let possibilities = weights.combinations().filter({ $0.sum == groupWeight })
        print(possibilities)
        
        return #function
    }
    
    override func part2() -> String {
        return #function
    }

}
