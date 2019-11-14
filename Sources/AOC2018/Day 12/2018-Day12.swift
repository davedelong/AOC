//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/11/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

extension Array {

func get(_ index: Int) -> Element? {
    if index < 0 || index >= endIndex { return nil }
    return self[index]
}

}

class Day12: Day {
    
    @objc init() {
//            super.init(inputSource: .raw(
//                """
//...## => #
//..#.. => #
//.#... => #
//.#.#. => #
//.#.## => #
//.##.. => #
//.#### => #
//#.#.# => #
//#.### => #
//##.#. => #
//##.## => #
//###.. => #
//###.# => #
//####. => #
//"""))
//
        
        super.init(inputSource: .file(#file))
    }
    
    lazy var fAndR: Dictionary<String, Character> = {
        let r = Regex(pattern: #"([\.#]{5}) => ([\.#])"#)
        let pieces = input.lines.raw.map { l -> (String, Character) in
            let m = l.match(r)
            return (m[1]!, m[2]!.first!)
        }
        return Dictionary(uniqueKeysWithValues: pieces)
    }()
    
    private func run(input: String, generations: Int) -> Int {
        var current = Array(input)
        
        var potOffset = current.firstIndex(of: "#")!
        let lastOn = current.lastIndex(of: "#")!
        current = Array(current[potOffset...lastOn])
        
        var loop = Dictionary<String, Int>()
        
        for g in 0 ..< generations {
            if g % 1000 == 0 { print(g) }
            var next = Array<Character>()
            for p in -2 ..< current.count + 2 {
                let characters = (p-2...p+2).map { current.get($0) ?? "." }
                let replace = fAndR[String(characters)] ?? "."
                next.append(replace)
            }
            
            potOffset -= 2
            let indexOfFirstOn = next.firstIndex(of: "#")!
            let indexOfLastOn = next.lastIndex(of: "#")!
            potOffset += indexOfFirstOn
            
            current = Array(next[indexOfFirstOn...indexOfLastOn])
            
            let thisLoop = String(current)
            if let loopGeneration = loop[thisLoop] {
                // we found where this loops
                let offset = generations % loopGeneration
//                    let targetGeneration =
            } else {
                loop[thisLoop] = g + 1
            }
        }
        
        let onPots = current.enumerated().filter { $0.element == "#" }.map { $0.offset + potOffset }.sum()
        return onPots
    }
    
    override func part1() -> String {
        andrew()
        
        let initial = "####..##.##..##..#..###..#....#.######..###########.#...#.##..####.###.#.###.###..#.####..#.#..##..#"
        let answer = run(input: initial, generations: 20)
        return "\(answer)"
    }
    
    override func part2() -> String {
        let initial = "####..##.##..##..#..###..#....#.######..###########.#...#.##..####.###.#.###.###..#.####..#.#..##..#"
        let answer = run(input: initial, generations: 50_000_000_000)
        return "\(answer)"
    }
    
    func aocD11(_ initial: String, _ rest: Dictionary<String, Character>) {
        var current = Array(initial)
        let updates = rest
        var start = 0
        var time = 0
        var seen: [String: (time: Int, offset: Int)] = [initial: (0, 0)]
        let finalTarget = 50000000000
        var printAt20 = 0
        while true {
            time += 1
            print(String(repeating: " ", count: start > 0 ? start : 0) + String(current))
            var new: [Character] = []
            for index in (-2)..<(current.count+2) {
                let str = String(((index - 2)...(index + 2)).lazy.map { current.get($0) ?? "." })
                let update = updates[str] ?? "."
                new.append(update)
            }
            start -= 2
            let first = new.firstIndex(of: "#")!
            let last = new.lastIndex(of: "#")!
            current = Array(new[first...last])
            start += first
            if let lastSeen = seen[String(current)] {
                let loopTime = time - lastSeen.time
                let finalPos = (finalTarget - lastSeen.time) % loopTime
                let final = seen.filter({ $0.value.time == finalPos + lastSeen.time }).first!
                
                let posMovement = start - lastSeen.offset
                let totalMovement = posMovement * ((finalTarget - lastSeen.time) / loopTime)
                let finalMovement = final.value.offset + totalMovement
                print(final.key.enumerated().lazy.filter({ $0.element == "#" }).map({ $0.offset + finalMovement }).reduce(0, +))
                break
            }
            else {
                seen[String(current)] = (time, start)
            }
            if (time == 20) {
                printAt20 = current.enumerated().lazy.filter({ $0.element == "#" }).map({ $0.offset + start }).reduce(0, +)
            }
        }
        print("Part A: \(printAt20)")
    }
    
    private func andrew() {
        
        let initialInput = "####..##.##..##..#..###..#....#.######..###########.#...#.##..####.###.#.###.###..#.####..#.#..##..#"
        let input = self.input.lines.raw
        
        func desc(of pots: [Bool]) -> String {
            return pots.map { $0 ? "#" : "." }.joined()
        }
        
        var pots = initialInput.map { $0 == "#" }
        let padding = 5
        pots.insert(contentsOf: Array<Bool>(repeating: false, count: padding), at: 0)
        pots.append(contentsOf: Array<Bool>(repeating: false, count: padding))
        var rules = [[Bool] : Bool]()
        for line in input {
            let comps = line.components(separatedBy: " ")
            let rule = comps[0].map { $0 == "#" }
            let result = comps[2]
            rules[rule] = result == "#"
        }
        //print(rules.map { "\(desc(of: $0.0)) => \($0.1 ? "#" : ".")" }.joined(separator: "\n"))
        
        //print("\(0):  \(desc(of: pots))")
        
        func sum(of pots: [Bool]) -> Int {
            return pots.enumerated().reduce(0) {
                $0 + ($1.element ? $1.offset - padding : 0)
            }
        }
        
        var valAt1K = 0
        for i in 1...2000 {
            var newPots = pots
            for index in 2..<pots.count {
                var pattern: [Bool]
                if index+2 >= pots.count {
                    pattern = Array(pots[(index-2)..<pots.count])
                    let padding = Array<Bool>(repeating: false, count: 5-pattern.count)
                    pattern.append(contentsOf: padding)
                    if !pattern.contains(true) { continue }
                    newPots.append(contentsOf: padding)
                } else {
                    pattern = Array(pots[(index-2)...(index+2)])
                }
                
                if let result = rules[pattern] {
                    newPots[index] = result
                } else {
                    newPots[index] = false
                }
            }
            //print("\(i):  \(desc(of: newPots))")
            
            if i == 20 {
                print("part 1: \(sum(of: newPots))")
            }
            
            if i == 1000 {
                valAt1K = sum(of: newPots)
            }
            
            if i == 2000 {
                let changePer1K = sum(of: newPots) - valAt1K
                let part2Result = sum(of: newPots) + ((50000000000 - 2000) / 1000) * changePer1K
                print("part 2: \(part2Result)")
            }
            
            pots = newPots
        }
    }
    
}
