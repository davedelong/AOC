//
//  Day24.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day24: Day {

//    func run() async throws -> (String, String) {
//        return ("", "")
//    }
    
    func part1() async throws -> Int { frontTrunkQE(for: 3) }
    
    func part2() async throws -> Int { frontTrunkQE(for: 4) }
    
    func frontTrunkQE(for partitionCount: Int) -> Int {
        let weights = input().integers
        let totalWeight = weights.sum
        let groupWeight = totalWeight / partitionCount
        
        var properCombos = Array<[Int]>()
        for packageCount in 1 ..< weights.count {
            let combos = weights.combinations(ofCount: packageCount)
            
            properCombos = combos.filter { $0.sum == groupWeight }
            if properCombos.isNotEmpty { break }
        }
        
        let qes = properCombos.map(\.product)
        return qes.min()!
    }

}
