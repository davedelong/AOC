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
        
        typealias ContainerGroup = Array<Int>
        
        private func combinations(of ints: Array<Int>, matching: (ContainerGroup) -> Bool = { _ in return true }) -> Array<ContainerGroup> {
            if ints.isEmpty { return [] }
            var final = Array<ContainerGroup>()
            for (index, int) in ints.enumerated() {
                var copy = ints
                copy.remove(at: index)
                var subCombinations = combinations(of: copy)
                subCombinations = subCombinations.compactMap {
                    let g = [int] + $0
                    return matching(g) ? g : nil
                }
                final.append(contentsOf: subCombinations)
            }
            return final
        }
        
        override public func part1() -> String {
            let containers = input.lines.integers.sorted(by: >)
            
            let combinations = self.combinations(of: containers, matching: { $0.sum() <= 150 })
            return "\(combinations.count)"
        }
        
        override public func part2() -> String {
            return #function
        }
        
    }

}
