//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/16/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

extension Year2015 {

    public class Day17: Day {
        
        public init() { super.init(inputSource: .file(#file)) }
        
        override public func run() -> (String, String) {
            let containers = input.lines.integers
            
            var containerIterator = CombinationIterator(containers)
            
            var matching = 0
            var numberOfContainersNeeded = Int.max
            var numberOfGroupsOfMinimumContainers = 0
            
            while let setOfContainers = containerIterator.next() {
                let s = setOfContainers.sum()
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
            
            return ("\(matching)", "\(numberOfGroupsOfMinimumContainers)")
        }
        
    }

}
