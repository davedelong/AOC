//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/16/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day17: Day {
    
    override func run() -> (String, String) {
        let containers = input.lines.integers
        
        var matching = 0
        var numberOfContainersNeeded = Int.max
        var numberOfGroupsOfMinimumContainers = 0
        
        for count in 1 ... containers.count {
            for setOfContainers in containers.combinations(ofCount: count) {
                let s = setOfContainers.sum
                if s == 150 {
                    matching += 1
                    
                    if setOfContainers.count < numberOfContainersNeeded {
                        numberOfContainersNeeded = setOfContainers.count
                        numberOfGroupsOfMinimumContainers = 1
                    } else if setOfContainers.count == numberOfContainersNeeded {
                        numberOfGroupsOfMinimumContainers += 1
                    }
                }
            }
        }
        
        return ("\(matching)", "\(numberOfGroupsOfMinimumContainers)")
    }

}
