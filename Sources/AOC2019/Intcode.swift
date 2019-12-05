//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/1/19.
//

import Foundation

let MAX_NUMBER_OF_ARGUMENTS = 3

struct Intcode {
    
    enum Mode {
        case positional
        case immediate
    }
    
    struct Operation: Hashable {
        static func ==(lhs: Operation, rhs: Operation) -> Bool { return lhs.instruction == rhs.instruction }
        
        static func interpret(pc: Int, memory: Array<Int>, arguments: Int) -> Array<Int> {
            var op = memory[pc]
            op /= 100 // chop off the instruction itself
            var modes: Array<Mode> = op.digits.map { $0 == 1 ? .immediate : .positional }
            while modes.count < arguments { modes.insert(.positional, at: 0) }
            return modes.reversed().enumerated().map { (index, mode) -> Int in
                let value = memory[pc + index + 1]
                if mode == .positional {
                    return memory[value]
                } else {
                    return value
                }
            }
        }
        
        static let add = Operation(instruction: 1, run: { pc, _, mem in
            let params = interpret(pc: pc, memory: mem, arguments: 3)
            mem[mem[pc+3]] = params[0] + params[1]
            pc += 4
        })
        static let multiply = Operation(instruction: 2, run: { pc, _, mem in
            let params = interpret(pc: pc, memory: mem, arguments: 3)
            mem[mem[pc+3]] = params[0] * params[1]
            pc += 4
        })
        static let set = Operation(instruction: 3, run: { pc, io, mem in
            mem[mem[pc+1]] = io
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
            let params = interpret(pc: pc, memory: mem, arguments: 3)
            mem[mem[pc+3]] = (params[0] < params[1]) ? 1 : 0
            pc += 4
        })
        static let equal = Operation(instruction: 8, run: { pc, io, mem in
            let params = interpret(pc: pc, memory: mem, arguments: 3)
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
    
    var memory: Array<Int>
    let ops: Dictionary<Int, Operation>
    
    init(memory: Array<Int>, supportedOperations: Set<Operation>) {
        self.memory = memory
        ops = supportedOperations.keyedBy { $0.instruction }
    }
    
    func run(input: Int = 0) -> Int {
        var pc = 0
        var io = input
        var mem = memory
        
        while pc < mem.count {
            let instruction = mem[pc] % 100 // get the last two digits
            guard let op = ops[instruction] else { fatalError("Unknown instruction: \(instruction)") }
            op.run(&pc, &io, &mem)
        }
        return input != 0 ? io : mem[0]
    }
}
