//
//  Day10.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

class Day10: Day {
    
    enum ParseResult {
        case complete
        case incomplete(String)
        case error(Character)
    }

    func run() async throws -> (Int, Int) {
        let lines = input().lines.characters
        var part1 = 0
        
        var completions = Array<String>()
        
        for line in lines {
            var slice = line[...]
            let result = parseChunk(&slice)
            if case .error(let c) = result {
                switch c {
                    case ")": part1 += 3
                    case "]": part1 += 57
                    case "}": part1 += 1197
                    case ">": part1 += 25137
                    default: continue
                }
            } else if case .incomplete(let completion) = result {
                completions.append(completion)
            }
        }
        
        let scores = completions.map { s -> Int in
            var score = 0
            for char in s {
                score *= 5
                switch char {
                    case ")": score += 1
                    case "]": score += 2
                    case "}": score += 3
                    case ">": score += 4
                    default: continue
                }
            }
            return score
        }
        let sortedScores = scores.sorted(by: <)
        let part2 = sortedScores.median()
        
        return (part1, part2)
    }
    
    private func parseChunk(_ remaining: inout ArraySlice<Character>) -> ParseResult {
        guard remaining.count > 0 else { return .incomplete("") }
        
        while let next = remaining.first {
            
            let close: Character
            switch next {
                case "[": close = "]"
                case "(": close = ")"
                case "{": close = "}"
                case "<": close = ">"
                default: return .complete
            }
            
            remaining = remaining.dropFirst()
            
            guard let peek = remaining.first else { return .incomplete(String(close)) }
        
            if peek != close {
                // this is the opening of a chunk
                // try to parse a chunk from this
                let result = parseChunk(&remaining)
                if case .error(let c) = result {
                    return .error(c)
                } else if case .incomplete(let s) = result {
                    return .incomplete(s + String(close))
                }
            }
            
            // after parsing the chunk, we should close now
            if let next = remaining.first {
                if next == close {
                    remaining = remaining.dropFirst()
                } else {
                    return .error(next)
                }
            } else {
                return .incomplete(String(close))
            }
        }
        return .complete
    }

}
