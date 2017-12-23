//
//  Day6.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

class Day6: Day {
    
    struct Seen: Hashable {
        static func ==(lhs: Seen, rhs: Seen) -> Bool { return lhs.array == rhs.array }
        let array: Array<Int>
        let hashValue: Int
        init(_ array: Array<Int>) {
            self.array = array
            self.hashValue = array.max()!
        }
        func redistribute() -> Seen {
            var copy = array
            var max = copy.max()!
            var index = copy.index(of: max)!
            copy[index] = 0
            while max > 0 {
                index = (index + 1) % copy.count
                copy[index] += 1
                max -= 1
            }
            return Seen(copy)
        }
    }
    
    let input = [2, 8, 8, 5, 4, 2, 3, 1, 5, 5, 1, 2, 15, 13, 5, 14]
    
    required init() { }
    
    func part1() {
        var current = Seen(input)
        var seen = Set<Seen>()
        
        repeat {
            seen.insert(current)
            current = current.redistribute()
        } while seen.contains(current) == false
        
        print(seen.count)
    }
    
    func part2() {
        var current = Seen(input)
        var seen = Dictionary<Seen, Int>()
        
        repeat {
            seen[current] = seen.count
            current = current.redistribute()
        } while seen[current] == nil
        
        print(seen.count - seen[current]!)
    }
    
}
