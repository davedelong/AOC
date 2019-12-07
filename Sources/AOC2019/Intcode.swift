//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/1/19.
//

import Foundation

class Intcode {
    
    struct Operation: Hashable {
        static func ==(lhs: Operation, rhs: Operation) -> Bool { return lhs.instruction == rhs.instruction }
        
        static func interpret(pc: Int, memory: Array<Int>, arguments: Int) -> Array<Int> {
            let digits = Array((memory[pc] / 100).digits.reversed()) // chop off the instruction itself
            return (0 ..< arguments).map { argIndex -> Int in
                let v = memory[pc + argIndex + 1]
                return (digits.at(argIndex) == 1) ? v : memory[v]
            }
        }
        
        static let add = Operation(instruction: 1, run: { pc, _, mem in
            let params = interpret(pc: pc, memory: mem, arguments: 2) // the third argument is ALWAYS positional
            mem[mem[pc+3]] = params[0] + params[1]
            pc += 4
        })
        static let multiply = Operation(instruction: 2, run: { pc, _, mem in
            let params = interpret(pc: pc, memory: mem, arguments: 2) // the third argument is ALWAYS positional
            mem[mem[pc+3]] = params[0] * params[1]
            pc += 4
        })
        static let set = Operation(instruction: 3, run: { pc, io, mem in
            mem[mem[pc+1]] = io // the first argument is ALWAYS positional
            pc += 2
        })
        static let get = Operation(instruction: 4, run: { pc, io, mem in
            let params = interpret(pc: pc, memory: mem, arguments: 1)
            io = params[0]
            pc += 2
        })
        static let jumpIfTrue = Operation(instruction: 5, run: { pc, io, mem in
            let params = interpret(pc: pc, memory: mem, arguments: 2)
            if params[0] != 0 {
                pc = params[1]
            } else {
                pc += 3
            }
        })
        static let jumpIfFalse = Operation(instruction: 6, run: { pc, io, mem in
            let params = interpret(pc: pc, memory: mem, arguments: 2)
            if params[0] == 0 {
                pc = params[1]
            } else {
                pc += 3
            }
        })
        static let lessThan = Operation(instruction: 7, run: { pc, io, mem in
            let params = interpret(pc: pc, memory: mem, arguments: 2) // the third argument is ALWAYS positional
            mem[mem[pc+3]] = (params[0] < params[1]) ? 1 : 0
            pc += 4
        })
        static let equal = Operation(instruction: 8, run: { pc, io, mem in
            let params = interpret(pc: pc, memory: mem, arguments: 2) // the third argument is ALWAYS positional
            mem[mem[pc+3]] = (params[0] == params[1]) ? 1 : 0
            pc += 4
        })
        static let `break` = Operation(instruction: 99, run: { pc, _, mem in
            pc = mem.count
        })
        
        let instruction: Int
        let run: (_ pc: inout Int, _ io: inout Int, _ memory: inout Array<Int>) -> Void
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(instruction)
        }
    }
    
    private(set) var memory: Array<Int>
    let ops: Dictionary<Int, Operation>
    
    var pc = 0
    var io = 0
    
    init(memory: Array<Int>, supportedOperations: Set<Operation>) {
        self.memory = memory
        ops = supportedOperations.keyedBy { $0.instruction }
    }
    
    func run(input: Int = 0) {
        io = input
        pc = 0
        while pc < memory.count {
            let instruction = memory[pc] % 100 // get the last two digits
            guard let op = ops[instruction] else { fatalError("Unknown instruction: \(instruction)") }
            op.run(&pc, &io, &memory)
        }
    }
}
