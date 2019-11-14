//
//  Day5.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day5: Day {
    
    init() { super.init(inputFile: #file) }
    
    override func part1() -> String {
        let vowels: Set<Character> = Set("aeiou")
        let illegals: Array<(Character, Character)> = [
            ("a", "b"), ("c", "d"), ("p", "q"), ("x", "y")
        ]
        
        let niceCount = input.lines.characters.count { line -> Bool in
            var vowelCount = 0
            var hasDoubled = false
            var previous: Character?
            
            for char in line {
                if vowels.contains(char) { vowelCount += 1 }
                if char == previous { hasDoubled = true }
                
                for i in illegals {
                    if previous == i.0 && char == i.1 { return false }
                }
                previous = char
            }
            if vowelCount < 3 { return false }
            if hasDoubled == false { return false }
            
            return true
        }
        return "\(niceCount)"
    }
    
    override func part2() -> String {
        let rule1 = Regex(pattern: "(..).*\\1") // a pair of characters repeated in the string
        let rule2 = Regex(pattern: "(.).\\1") // a character repeated w/ a single character in between
        let niceCount = input.lines.raw.count { line -> Bool in
            return rule1.matches(line) && rule2.matches(line)
        }
        return "\(niceCount)"
    }
    
}
