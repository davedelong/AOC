//
//  Day5.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day5: Day {
    
    @objc init() { super.init(inputFile: #file) }
    
    private func reduce(_ chars: Array<Character>, skipping: Set<Character> = []) -> Array<Character> {
        let uppers = Array(String(chars).uppercased())
        
        var final = Array<Character>()
        var upperFinal = Array<Character>()
        for i in 0 ..< chars.count {
            if skipping.contains(chars[i]) { continue }
            if upperFinal.last == uppers[i], final.last != chars[i] {
                final.removeLast()
                upperFinal.removeLast()
            } else {
                final.append(chars[i])
                upperFinal.append(uppers[i])
            }
        }
        return final
    }
    
    override func part1() -> String {
        let characters = reduce(input.characters)
        return "\(characters.count)"
    }
    
    override func part2() -> String {
        let source = input.characters
        let lengths = Character.alphabet.map { reduce(source, skipping: [$0, $0.uppercased]).count }
        let shortest = lengths.min()!
        return "\(shortest)"
    }

}
