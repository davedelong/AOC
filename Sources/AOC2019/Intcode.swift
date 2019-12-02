//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/1/19.
//

import Foundation

struct Intcode {
    
    struct Operation: Hashable {
        static func ==(lhs: Operation, rhs: Operation) -> Bool { return lhs.instruction == rhs.instruction }
        
        static let add = Operation(instruction: 1, run: { pc, mem in
            let p1 = mem[pc + 1]
            let p2 = mem[pc + 2]
            let p3 = mem[pc + 3]
            mem[p3] = mem[p1] + mem[p2]
            pc += 4
        })
        static let multiply = Operation(instruction: 2, run: { pc, mem in
            let p1 = mem[pc + 1]
            let p2 = mem[pc + 2]
            let p3 = mem[pc + 3]
            mem[p3] = mem[p1] * mem[p2]
            pc += 4
        })
        static let `break` = Operation(instruction: 99, run: { pc, mem in
            pc = mem.count
        })
        
        let instruction: Int
        let run: (_ pc: inout Int, _ memory: inout Array<Int>) -> Void
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(instruction)
        }
    }
    
    var memory: Array<Int>
    let ops: Dictionary<Int, Operation>
    
    init(memory: Array<Int>, supportedOperations: Set<Operation>) {
        self.memory = memory
        ops = supportedOperations.keyedBy { $0.instruction }
    }
    
    func run() -> Int {
        var pc = 0
        var mem = memory
        
        while pc < mem.count {
            let instruction = memory[pc]
            guard let op = ops[instruction] else { fatalError("Unknown instruction: \(instruction)") }
            op.run(&pc, &mem)
        }
        return mem[0]
    }
}
