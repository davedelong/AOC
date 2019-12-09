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
    
    private func get(_ argIndex: Int) -> Int {
        let mode = (memory[pc] / 100).digits.reversed().at(argIndex) ?? 0
        let v = memory[pc + argIndex + 1]
        switch mode {
            case 0: return memory[v]
            case 1: return v
            case 2: return memory[relativeBase + v]
            default: fatalError()
        }
    }
    
    private func set(_ argIndex: Int, newValue: Int) {
        let mode = (memory[pc] / 100).digits.reversed().at(argIndex) ?? 0
        let v = memory[pc + argIndex + 1]
        switch mode {
            case 0: memory[v] = newValue
            case 1: fatalError() // cannot set in immediate mode
            case 2: memory[relativeBase + v] = newValue
            default: fatalError()
        }
    }
    
    func step() {
        let instruction = memory[pc] % 100
        
        switch instruction {
            case .add: // add
                set(2, newValue: get(0) + get(1))
                pc += 4
            case .multiply: // multiply
                set(2, newValue: get(0) * get(1))
                pc += 4
            case .read: // read from IO
                set(0, newValue: io!)
                pc += 2
            case .write: // write to IO
                io = get(0)
                pc += 2
            case .jumpIfTrue: // jump if true
                if get(0) != 0 {
                    pc = get(1)
                } else {
                    pc += 3
                }
            case .jumpIfFalse: // jump if false
                if get(0) == 0 {
                    pc = get(1)
                } else {
                    pc += 3
                }
            case .lessThan: // less than
                set(2, newValue: get(0) < get(1) ? 1 : 0)
                pc += 4
            case .equal: // equal
                set(2, newValue: get(0) == get(1) ? 1 : 0)
                pc += 4
            
            case .adjustRelativeBase:
                relativeBase += get(0)
                pc += 2
            
            case .break: // break
                isHalted = true
            
            default:
                fatalError("Unknown instruction: \(instruction)")
        }
    }
}
