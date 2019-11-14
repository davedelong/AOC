//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/20/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

fileprivate let A = 0
fileprivate let B = 1
fileprivate let C = 2

class Day21: Day {
    
    typealias Registers = Array<Int>
    
    struct Opcode: Hashable {
        static let all = [addr, addi,
                          mulr, muli,
                          banr, bani,
                          borr, bori,
                          setr, seti,
                          gtir, gtri, gtrr,
                          eqir, eqri, eqrr]
        static let addr = Opcode(name: "addr") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] + regs[inst[B]]
        }
        static let addi = Opcode(name: "addi") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] + inst[B]
        }
        static let mulr = Opcode(name: "mulr") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] * regs[inst[B]]
        }
        static let muli = Opcode(name: "muli") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] * inst[B]
        }
        static let banr = Opcode(name: "banr") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] & regs[inst[B]]
        }
        static let bani = Opcode(name: "bani") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] & inst[B]
        }
        static let borr = Opcode(name: "borr") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] | regs[inst[B]]
        }
        static let bori = Opcode(name: "bori") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] | inst[B]
        }
        static let setr = Opcode(name: "setr") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]]
        }
        static let seti = Opcode(name: "seti") { (regs, inst) in
            regs[inst[C]] = inst[A]
        }
        static let gtir = Opcode(name: "gtir") { (regs, inst) in
            regs[inst[C]] = inst[A] > regs[inst[B]] ? 1 : 0
        }
        static let gtri = Opcode(name: "gtri") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] > inst[B] ? 1 : 0
        }
        static let gtrr = Opcode(name: "gtrr") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] > regs[inst[B]] ? 1 : 0
        }
        static let eqir = Opcode(name: "eqir") { (regs, inst) in
            regs[inst[C]] = inst[A] == regs[inst[B]] ? 1 : 0
        }
        static let eqri = Opcode(name: "eqri") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] == inst[B] ? 1 : 0
        }
        static let eqrr = Opcode(name: "eqrr") { (regs, inst) in
            regs[inst[C]] = regs[inst[A]] == regs[inst[B]] ? 1 : 0
        }
        
        static func ==(lhs: Opcode, rhs: Opcode) -> Bool {
            return lhs.name == rhs.name
        }
        
        let name: String
        let execute: (inout Registers, Array<Int>) -> Void
        func hash(into hasher: inout Hasher) { hasher.combine(name) }
    }
    
    struct Instruction {
        let opcode: Opcode
        let arguments: Array<Int>
    }
    
    lazy var boundRegister: Int = {
        return input.lines[0].words[1].integer!
    }()
    
    lazy var instructions: Array<Instruction> = {
        let codes = Opcode.all.keyedBy { $0.name }
        
        let r = Regex(pattern: #"(.+?) (\d+) (\d+) (\d+)"#)
        return input.lines.raw.compactMap { line -> Instruction? in
            guard let m = r.match(line) else { return nil }
            guard let code = codes[m[1]!] else { return nil }
            return Instruction(opcode: code, arguments: [m.int(2)!, m.int(3)!, m.int(4)!])
        }
    }()
    
    private func testInstructions(_ r0: Int) -> Int {
        var registers = [r0, 0, 0, 0, 0, 0]
        var pc = 0
        
        var instCount = 0;
        while pc < instructions.count {
            let inst = instructions[pc]
            registers[boundRegister] = pc
            inst.opcode.execute(&registers, inst.arguments)
            
            if pc == 28 {
                return registers[3]
            }
            
            pc = registers[boundRegister] + 1
            instCount += 1
        }
        return instCount
    }
    
    override func part1() -> String {
        var registers = [0, 0, 0, 0, 0, 0]
        var pc = 0
        
        while pc < instructions.count {
            let inst = instructions[pc]
            registers[boundRegister] = pc
            inst.opcode.execute(&registers, inst.arguments)
            
            if pc == 28 {
                // the instructions would exit iff r3 == r0
                // so the first time we make that check, let's see what r3 is
                // and that's the lowest/first value we'll need to exit
                return "\(registers[3])"
            }
            
            pc = registers[boundRegister] + 1
        }
        fatalError("Unreachable")
    }
    
    override func part2() -> String {
        var possibleR0Values = Set<Int>()
        var previousR0Value = 0
        
        var registers = [0, 0, 0, 0, 0, 0]
        var pc = 0
        
        while pc < instructions.count {
            let inst = instructions[pc]
            registers[boundRegister] = pc
            inst.opcode.execute(&registers, inst.arguments)
            
            if pc == 28 {
                let r3 = registers[3]
                if possibleR0Values.contains(r3) {
                    return "\(previousR0Value)"
                }
                possibleR0Values.insert(r3)
                previousR0Value = r3
            }
            
            pc = registers[boundRegister] + 1
        }
        fatalError("Unreachable")
    }
    /*
     instruction 5 is where things "start", because 0 - 4 are the the "bani" logic check
     05   seti 0 4 3            r3 = 0                  r3 = 0
     06   bori 3 65536 4        r4 = r3 | 65536         r4 = 65536
     07   seti 1107552 3 3      r3 = 1107552            r3 = 1107552
     08   bani 4 255 5          r5 = r4 & 255           r5 = 65536 & 255 == 0
     09   addr 3 5 3            r3 = r3 + r5            r3 = 1107552
     10   bani 3 16777215 3     r3 = r3 & 16777215      r3 = 1082464
     11   muli 3 65899 3        r3 = r3 * 65899         r3 = 71333295136
     12   bani 3 16777215 3     r3 = r3 & 16777215      r3 = 13349920
     13   gtir 256 4 5          r5 = 256 > r4 ? 1 : 0   r5 = 0
     14   addr 5 2 2            pc = pc + r5            pc = 14
     15   addi 2 1 2            pc = pc + 1             goto 17
     16   seti 27 0 2           pc = 27                 goto 28
     17   seti 0 2 5            r5 = 0                  r5 = 0
     18   addi 5 1 1            r1 = r5 + 1             r1 = 1
     19   muli 1 256 1          r1 = r1 * 256           r1 = 256
     20   gtrr 1 4 1            r1 = r1 > r4 ? 1 : 0    r1 = 0
     21   addr 1 2 2            pc = r1 + pc            pc = 21
     22   addi 2 1 2            pc = pc + 1             goto 24
     23   seti 25 3 2           pc = 25                 goto 26
     24   addi 5 1 5            r5 = r5 + 1             r5 = 1
     25   seti 17 3 2           pc = 17                 goto 18
     26   setr 5 3 4            r4 = r5
     27   seti 7 4 2            pc = 7                  goto 8
     28   eqrr 3 0 5            r5 = r3 == r0 ? 1 : 0
     29   addr 5 2 2            pc = r5 + pc            if r3 == r0 { exit }
     30   seti 5 8 2            pc = 5                  goto 6
     */
    
}
