//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/5/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

fileprivate class Op {
    let name: String
    var duration: UInt8 { return name.utf8.first! - 64 }
    var deps = Set<String>()
    init(name: String) { self.name = name }
}

class Day7: Day {
    
    private func operations() -> Array<Op> {
        
        let r = Regex(#"Step ([A-Z]) must be finished before step ([A-Z]) can begin\."#)
        
        var operations = Dictionary<String, Op>()
        
        for line in input().lines.raw {
            let match = r.firstMatch(in: line)!
            let dName = match[1]!
            let oName = match[2]!
            
            let d = operations[dName] ?? Op(name: dName)
            operations[dName] = d
            
            let o = operations[oName] ?? Op(name: oName)
            operations[oName] = o
            
            o.deps.insert(dName)
        }
        
        return Array(operations.values).sorted { $0.name < $1.name }
    }
    
    func part1() async throws -> String {
        var remaining = operations()
        var final = ""
        while remaining.isNotEmpty {
            let next = remaining.filter { $0.deps.isEmpty }.first!
            final += next.name
            for op in remaining { op.deps.remove(next.name) }
            remaining.removeAll { $0 === next }
        }
        
        return final
    }
    
    func part2() async throws -> String {
        var tick = 0
        
        var workers: Array<(Op?, UInt8)> = [
            (nil, 0),
            (nil, 0),
            (nil, 0),
            (nil, 0),
            (nil, 0)
        ]
        
        var remaining = operations()
        
        while remaining.isNotEmpty || workers.any(satisfy: { $0.0 != nil }) {
            tick += 1
            
            var updatedWorkers = Array<(Op?, UInt8)>()
            for w in workers {
                if w.1 <= 1 {
                    if let n = w.0?.name { remaining.forEach { $0.deps.remove(n) } }
                    
                    if let next = remaining.firstIndex(where: { $0.deps.isEmpty }) {
                        let op = remaining[next]
                        updatedWorkers.append((op, op.duration + 60))
                        remaining.remove(at: next)
                    } else {
                        updatedWorkers.append((nil, 0))
                    }
                } else {
                    updatedWorkers.append((w.0, w.1 - 1))
                }
            }
            workers = updatedWorkers
        }
        
        // subtract 1 because the last loop doesn't count, as it's just resetting everything back to empty
        return "\(tick-1)"
    }

}
