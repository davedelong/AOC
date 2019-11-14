//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/13/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day14: Day {
    
    @objc override init() { super.init(rawInput: "330121") }
    
    override func part1() -> String {
        
        var scores = [3, 7]
        
        var elf1Position = 0
        var elf2Position = 1
        
        let target = input.integer!
        
        while scores.count < target+10 {
            let e1Score = scores[elf1Position]
            let e2Score = scores[elf2Position]
            let elfSum = e1Score + e2Score
            
            if elfSum >= 10 { scores.append(elfSum / 10) }
            scores.append(elfSum % 10)
            
            // move the elves
            
            elf1Position = (elf1Position + e1Score + 1) % scores.count
            elf2Position = (elf2Position + e2Score + 1) % scores.count
        }
        
        let last10 = scores[target ..< (target+10)]
        let answer = last10.map { "\($0)" }.joined()
        
        return answer
    }
    
    override func part2() -> String {
        
        var scores = [3, 7]
        
        var elf1Position = 0
        var elf2Position = 1
        var lastScanPosition = 0
        let scanningFor = ArraySlice(input.characters.integers)
        
        while true {
            let e1Score = scores[elf1Position]
            let e2Score = scores[elf2Position]
            let elfSum = e1Score + e2Score
            
            if elfSum >= 10 { scores.append(elfSum / 10) }
            scores.append(elfSum % 10)
            
            // move the elves
            
            elf1Position = (elf1Position + e1Score + 1) % scores.count
            elf2Position = (elf2Position + e2Score + 1) % scores.count
            
            while lastScanPosition + scanningFor.count <= scores.count {
                let digits = scores[lastScanPosition..<(lastScanPosition + scanningFor.count)]
                if digits == scanningFor { return "\(lastScanPosition)" }
                lastScanPosition += 1
            }
        }
    }
    
}
