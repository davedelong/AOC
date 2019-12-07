//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/1/19.
//

import Foundation

fileprivate extension Int {
    static let add = 1
    static let multiply = 2
    static let read = 3
    static let write = 4
    static let jumpIfTrue = 5
    static let jumpIfFalse = 6
    static let lessThan = 7
    static let equal = 8
    
    static let `break` = 99
}

class Intcode {
    
    private(set) var memory: Array<Int>
    private var pc = 0
    
    var io: Int?
    var isHalted: Bool { return pc >= memory.count }
    
    init(memory: Array<Int>, input: Int? = nil) {
        self.memory = memory
        self.io = input
    }
    
    func resetPC() { pc = 0 }
    
    func needsIO() -> Bool {
        return isHalted == false && (memory[pc] % 100 == .read) && io == nil
    }
    
    func hasIO() -> Bool { return io != nil }
    
    func runUntilBeforeNextIO() {
        while isHalted == false {
            if memory[pc] % 100 == .write { return }
            if memory[pc] % 100 == .read { return }
            step()
        }
    }
    
    func runUntilNextEvent() {
        while isHalted == false {
            if needsIO() { return }
            let willHaveIO = (memory[pc] % 100 == .write)
            step()
            if willHaveIO { return }
        }
    }
    
    func runUntilNeedsIO() {
        while isHalted == false && needsIO() == false {
            step()
        }
    }
    
    @discardableResult
    func run() -> Int {
        while isHalted == false { step() }
        return io ?? 0
    }
    
    fileprivate func interpret(_ argCount: Int) -> Array<Int> {
        let digits = Array((memory[pc] / 100).digits.reversed()) // chop off the instruction itself
        return (0 ..< argCount).map { argIndex -> Int in
            let v = memory[pc + argIndex + 1]
            return (digits.at(argIndex) == 1) ? v : memory[v]
        }
    }
    
    func step() {
        let instruction = memory[pc] % 100
        
        switch instruction {
            case .add: // add
                let params = interpret(2) // the third argument is ALWAYS positional
                memory[memory[pc+3]] = params[0] + params[1]
                pc += 4
            case .multiply: // multiply
                let params = interpret(2) // the third argument is ALWAYS positional
                memory[memory[pc+3]] = params[0] * params[1]
                pc += 4
            case .read: // read from IO
                memory[memory[pc+1]] = io! // the first argument is ALWAYS positional
                pc += 2
            case .write: // write to IO
                let params = interpret(1)
                io = params[0]
                pc += 2
            case .jumpIfTrue: // jump if true
                let params = interpret(2)
                if params[0] != 0 {
                    pc = params[1]
                } else {
                    pc += 3
                }
            case .jumpIfFalse: // jump if false
                let params = interpret(2)
                if params[0] == 0 {
                    pc = params[1]
                } else {
                    pc += 3
                }
            case .lessThan: // less than
                let params = interpret(2) // the third argument is ALWAYS positional
                memory[memory[pc+3]] = (params[0] < params[1]) ? 1 : 0
                pc += 4
            case .equal: // equal
                let params = interpret(2) // the third argument is ALWAYS positional
                memory[memory[pc+3]] = (params[0] == params[1]) ? 1 : 0
                pc += 4
            
            case .break: // break
                pc = memory.count
            
            default:
                fatalError("Unknown instruction: \(instruction)")
        }
    }
}
