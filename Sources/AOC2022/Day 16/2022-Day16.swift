//
//  Day16.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day16: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    typealias Valve = Int
    
    func parseInput() -> Graph<String, Valve> {
        let r = Regex(#"([A-Z]{2})"#)
        
        var g = Graph<String, Valve>()
        g.defaultTravelCost = 1
        
        for line in input().lines {
            let matches = r.matches(in: line.raw)
            
            let valve = matches[0][0]!
            let flow = line.integers[0]
            
            g[valve] = flow
            
            for other in matches.dropFirst() {
                let v = other[0]!
                if g[v] == nil { g[v] = 0 }
                g.connect(valve, to: v)
            }
        }
        
        return g
    }
    
    struct Option {
        let start: String
        let end: String
        var travelTime: Int
        var pressure: Int
    }
    
    func parseOptions() -> Array<Option> {
        let g = parseInput()
        
        var options = Array<Option>()
        for (node, _) in g {
            for (other, p) in g {
                var option = Option(start: node, end: other, travelTime: 0, pressure: p)
                if node != other {
                    let path = g.path(from: node, to: other)
                    option.travelTime = Int(g.cost(of: path)!)
                }
                if option.travelTime > 0 && option.pressure > 0 {
                    options.append(option)
                }
            }
        }
        
        return options
    }
    
    func part1() async throws -> Part1 {
        return 1828
        
        let maxTime = 30
        let options = parseOptions()
        
        let all = self.findOptions(from: "AA", options: options, timeRemaining: maxTime)
        print("All:", all.count)
        let lookup = Dictionary(uniqueKeysWithValues: options.map {
            (Pair($0.start, $0.end), $0)
        })
        
        let viable = all.filter { path in
            let time = path.adjacentPairs().sum(of: { (s, e) -> Int in
                let opt = lookup[Pair(s, e)]!
                return opt.travelTime + 1
            })
            return time <= maxTime
        }
        print("VIABLE", viable.count)
        
        let pressures = viable.map({ path in
            var remaining = maxTime
            let pressure = path.adjacentPairs().sum(of: { (s, e) -> Int in
                let opt = lookup[Pair(s, e)]!
                remaining -= (opt.travelTime + 1)
                return Int(remaining) * opt.pressure
            })
            return pressure
        })
        
        let p1 = pressures.max()!
        print("P1", p1)
        return p1
    }
    
    func part2() async throws -> Part2 {
        let maxTime = 26
        
        let options = parseOptions()
        let all = Set((1 ... maxTime).flatMap { t -> [Path] in
            print("Testing time \(t)")
            return self.findOptions(from: "AA", options: options, timeRemaining: t)
        })
        print("ALL", all.count)
        
        let lookup = Dictionary(uniqueKeysWithValues: options.map {
            (Pair($0.start, $0.end), $0)
        })
        
        let viable = Array(all.filter { path in
            let time = path.adjacentPairs().sum(of: { (s, e) -> Int in
                let opt = lookup[Pair(s, e)]!
                return opt.travelTime + 1
            })
            return time <= maxTime
        })
        
        // for part 2, we need to find two sets of paths that don't intersect
        
        func pressure(of path: Path) -> Int {
            var remaining = maxTime
            return path.adjacentPairs().sum(of: { (s, e) -> Int in
                let opt = lookup[Pair(s, e)]!
                remaining -= (opt.travelTime + 1)
                return Int(remaining) * opt.pressure
            })
        }
        // You: AA, JJ, BB, CC
        // Elephant: AA, DD, HH, EE
        
        print("Viable", viable.count)
        
        let bits = Array(Set(options.flatMap { [$0.start, $0.end] }))
        
        let sets = Dictionary(uniqueKeysWithValues: viable.enumerated().map { (i, p) in
            var bitSet = 0
            for v in p.dropFirst() {
                let bit = bits.firstIndex(of: v)!
                bitSet.toggleBit(bit)
            }
            return (i, bitSet)
        })
        let pressures = Dictionary(uniqueKeysWithValues: viable.enumerated().map { (i, p) in
            return (i, pressure(of: p))
        })
        
        var p2 = 0
        for i in viable.indices {
            if i % 10 == 0 { print("\(i) of \(viable.count)") }
            let p1Set = sets[i]!
            let p1Pressure = pressures[i]!
            
            for o in viable.indices {
                if i == o { continue }
                let p2Set = sets[i]!
                if p1Set & p2Set != 0 { continue }
                
                let p2Pressure = pressures[o]!
                
                let total = p1Pressure + p2Pressure
                p2 = Swift.max(p2, total)
            }
            
        }
        
        return p2
    }

    typealias Path = [String]
    func findOptions(from current: String, options: Array<Option>, timeRemaining: Int) -> [Path] {
        let potentials = options.filter { $0.start == current }
        if potentials.isEmpty {
            return [[current]]
        }
        
        let recursivePotentials = options.filter { $0.end != current && timeRemaining > ($0.travelTime + 1) }
        if recursivePotentials.isEmpty {
            return [[current]]
        }
        
        return potentials.flatMap { p in
            let pathsFromP = findOptions(from: p.end, options: recursivePotentials, timeRemaining: timeRemaining - p.travelTime - 1)
            return pathsFromP.map { [current] + $0 }
        }
    }

}
