//
//  Day6.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2016 Dave DeLong. All rights reserved.
//

class Day6: Day {
    
    func part1() async throws -> String {
        let characters = input().lines.characters
        
        let columns = characters.transposed()
        let letters = columns.map { col in
            let freqs = col.countElements()
            return freqs.mostCommon()!
        }
        
        return String(letters)
    }
    
    func part2() async throws -> String {
        let characters = input().lines.characters
        
        let columns = characters.transposed()
        let letters = columns.map { col in
            let freqs = col.countElements()
            return freqs.leastCommon()!
        }
        
        return String(letters)
    }

}
