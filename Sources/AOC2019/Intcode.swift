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
    static let adjustRelativeBase = 9
    
    static let `break` = 99
}

class Intcode {
    
    private(set) var memory: Sparse<Int>
    private var pc = 0
    private var relativeBase = 0
    
    var io: Int?
    private(set) var isHalted: Bool = false
    
    init(memory: Array<Int>, input: Int? = nil) {
        self.memory = Sparse(memory, default: 0)
        self.io = input
    }
    
    func resetPC() {
        pc = 0
        isHalted = false
    }
    
    func needsIO() -> Bool {
        return isHalted == false && (memory[pc] % 100 == .read)
    }
    
    func hasIO() -> Bool { return io != nil }
    
    func runUntilBeforeNextIO() {
        while isHalted == false {
            if memory[pc] % 100 == .write { return }
            if memory[pc] % 100 == .read { return }
            step()
        }
    }
    
    func runUntilAfterNextOutput() {
        while isHalted == false {
            let shouldStop = (memory[pc] % 100 == .write)
            step()
            if shouldStop { return }
        }
    }
    
    @discardableResult
    func run() -> Int {
        while isHalted == false { step() }
        return io ?? 0
    }
    
    private subscript(argIndex: Int) -> Int {
        get {
            let mask = pow(10.0, Double(argIndex + 2))
            let mode = (memory[pc] / Int(mask)) % 10
            let v = memory[pc + argIndex + 1]
            switch mode {
                case 0: return memory[v]
                case 1: return v
                case 2: return memory[relativeBase + v]
                default: fatalError()
            }
        }
        
        set {
            let mask = pow(10.0, Double(argIndex + 2))
            let mode = (memory[pc] / Int(mask)) % 10
            let v = memory[pc + argIndex + 1]
            switch mode {
                case 0: memory[v] = newValue
                case 1: fatalError() // cannot set in immediate mode
                case 2: memory[relativeBase + v] = newValue
                default: fatalError()
            }
        }
    }
    
    func step() {
        let instruction = memory[pc] % 100
        
        switch instruction {
            case .add: // add
                self[2] = self[0] + self[1]
                pc += 4
            case .multiply: // multiply
                self[2] = self[0] * self[1]
                pc += 4
            case .read: // read from IO
                self[0] = io!
                pc += 2
            case .write: // write to IO
                io = self[0]
                pc += 2
            case .jumpIfTrue: // jump if true
                if self[0] != 0 {
                    pc = self[1]
                } else {
                    pc += 3
                }
            case .jumpIfFalse: // jump if false
                if self[0] == 0 {
                    pc = self[1]
                } else {
                    pc += 3
                }
            case .lessThan: // less than
                self[2] = self[0] < self[1] ? 1 : 0
                pc += 4
            case .equal: // equal
                self[2] = self[0] == self[1] ? 1 : 0
                pc += 4
            
            case .adjustRelativeBase:
                relativeBase += self[0]
                pc += 2
            
            case .break: // break
                isHalted = true
            
            default:
                fatalError("Unknown instruction: \(instruction)")
        }
    }
}
