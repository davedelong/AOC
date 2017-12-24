//
//  Day24.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import GameplayKit

class Day24: Day {
    
    typealias Chain = Array<Port>
    
    struct Port: Hashable {
        static func ==(lhs: Port, rhs: Port) -> Bool { return lhs.id == rhs.id }
        let id: Int
        let a: Int
        let b: Int
        var score: Int { return a + b }
        var hashValue: Int { return score }
        
        init(id: Int, string: String) {
            let p = string.split(separator: "/")
            self.id = id
            a = Int(p[0])!
            b = Int(p[1])!
        }
        
        func input(thatsNot: Int) -> Int { return thatsNot == a ? b : a }
        func has(input: Int) -> Bool { return a == input || b == input }
    }
    
    let ports: Set<Port>
    
    required init() {
        ports = Set(Day24.inputLines().enumerated().map { Port(id: $0.offset, string: $0.element) })
    }
    
    func nextItem(in chain: Chain) -> Int {
        var next = 0
        for p in chain {
            next = p.input(thatsNot: next)
        }
        return next
    }
    
    func extend(chain: Chain) -> Array<Chain> {
        let nextInput = nextItem(in: chain)
        let remainingPorts = ports.subtracting(chain)
        let nextPorts = remainingPorts.filter { $0.has(input: nextInput) }
        
        if nextPorts.count == 0 { return [] }
        return nextPorts.map { chain + [$0] }
    }
    
    func run() -> (String, String) {
        
        var unimprovableChains = Array<Chain>()
        var improvableChains = extend(chain: [])
        
        while improvableChains.isEmpty == false {
            
            var newChains = Array<Chain>()
            
            for chain in improvableChains {
                let extensions = extend(chain: chain)
                
                if extensions.isEmpty {
                    unimprovableChains.append(chain)
                } else {
                    newChains.append(contentsOf: extensions)
                }
            }
            improvableChains = newChains
        }
        
        let chainsAndScores = unimprovableChains.map { ($0, $0.reduce(0, {$0 + $1.score}))}
        let max = chainsAndScores.max(by: { $0.1 < $1.1 })!
        
        let longest = chainsAndScores.max(by: {
            if $0.0.count < $1.0.count { return true }
            if $0.0.count == $1.0.count { return $0.1 < $1.1 }
            return false
        })!
        
        return ("\(max.1)", "\(longest.1)")
    }
    
}
