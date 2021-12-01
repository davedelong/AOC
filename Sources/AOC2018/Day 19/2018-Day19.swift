//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/18/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

fileprivate let A = 0
fileprivate let B = 1
fileprivate let C = 2

class Day19: Day {
    
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
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
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
        
        let r = Regex(#"(.+?) (\d+) (\d+) (\d+)"#)
        return input.lines.raw.compactMap { line -> Instruction? in
            guard let m = r.firstMatch(in: line) else { return nil }
            guard let code = codes[m[1]!] else { return nil }
            return Instruction(opcode: code, arguments: [m.int(2)!, m.int(3)!, m.int(4)!])
        }
    }()
    
    override func part1() -> String {
        var registers = [0, 0, 0, 0, 0, 0]
        var pc = 0
        
        while pc < instructions.count {
            let inst = instructions[pc]
            registers[boundRegister] = pc
            inst.opcode.execute(&registers, inst.arguments)
            pc = registers[boundRegister] + 1
        }
        
        return "\(registers[0])"
    }
    
    override func part2() -> String {
        var answer = 0
        let target = 10551355
        for i in 1 ... target {
            if target % i == 0 { answer += i }
        }
        return "\(answer)"
        
        /*
        // the instructions basically translate into this:
        var r0 = 0
        var r1 = 0
        var r3 = 0
        
        while true {
            r3 = 1
            while (r3 <= 10551355) {
                if (r1 * r3 == 10551355) {
                    // every time we find a number that divides evenly into our target number,
                    // add that number to the final result
                    r0 = r1 + r0
                }
                r3 += 1
            }
            r1 += 1
            if r1 > 10551355 { return "\(r0)" }
        }
        
        // every time a number divides evenly in to our target number, we add it to our final answer
        // this means we're finding the sum of every divisor of our target number
         */
    }
    
    /*
  00   addi 2 16 2        pc = pc + 16
  01   seti 1 0 1         r[1] = 1
  02   seti 1 4 3         r[3] = 1
  03   mulr 1 3 4         r[4] = r[1] * r[3]
  04   eqrr 4 5 4         r[4] = (r[4] == r[5]) ? 1 : 0
  05   addr 4 2 2         pc = r[4] + pc        // if r[4] == 1, goto 7
  06   addi 2 1 2         pc = pc + 1           // goto 8
  07   addr 1 0 0         r[0] = r[1] + r[0]
  08   addi 3 1 3         r[3] = r[3] + 1
  09   gtrr 3 5 4         r[4] = (r[3] > r[5]) ? 1 : 0
  10   addr 2 4 2         pc = pc + r[4]
  11   seti 2 5 2         pc = 2                // goto 3
  12   addi 1 1 1         r[1] = r[1] + 1
  13   gtrr 1 5 4         r[4] = r[1] > r[5] ? 1 : 0 // when r[1] > r[5], exit
  14   addr 4 2 2         pc = r[4] + pc        // if r[4] == 1, goto 16
  15   seti 1 1 2         pc = 1                // else goto 2
  16   mulr 2 2 2         pc = pc * pc          // exit (pc ends up as 16 * 16 = 256)
  17   addi 5 2 5         r[5] = r[5] + 2       // r[5] = 2
  18   mulr 5 5 5         r[5] = r[5] * r[5]    // r[5] = 10
  19   mulr 2 5 5         r[5] = pc * r[5]      // r[5] = 76
  20   muli 5 11 5        r[5] = r[5] * 11      // r[5] = 836
  21   addi 4 5 4         r[4] = r[4] + 5       // r[4] = 5
  22   mulr 4 2 4         r[4] = r[4] * pc      // r[4] = 110
  23   addi 4 9 4         r[4] = r[4] + 9       // r[4] = 119
  24   addr 5 4 5         r[5] = r[5] + r[4]    // r[5] = 955
  25   addr 2 0 2         pc = pc + r[0]        // if r[0] == 1, goto 27
  26   seti 0 0 2         pc = 0                // else goto 1
  27   setr 2 3 4         r[4] = pc             // r[4] = 27
  28   mulr 4 2 4         r[4] = r[4] * pc      // r[4] = 756
  29   addr 2 4 4         r[4] = pc + r[4]      // r[4] = 785
  30   mulr 2 4 4         r[4] = pc * r[4]      // r[4] = 23550
  31   muli 4 14 4        r[4] = r[4] * 14      // r[4] = 329700
  32   mulr 4 2 4         r[4] = r[4] * pc      // r[4] = 10550400
  33   addr 5 4 5         r[5] = r[5] + r[4]    // r[5] = 10551355
  34   seti 0 6 0         r[0] = 0              // r[0] = 0
  35   seti 0 3 2         pc = 0                // goto 1
*/
    
}
