//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/15/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

fileprivate let A = 1
fileprivate let B = 2
fileprivate let C = 3

class Day16: Day {
    
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
        
        func matches(_ change: Change) -> Bool {
            var produced = change.before
            execute(&produced, change.instructions)
            return produced == change.after
        }
    }
    
    struct Change {
        let before: Registers
        let instructions: Array<Int>
        let after: Registers
    }
    
    lazy var changes: Array<Change> = {
        let r = Regex(#"Before:\s+\[(\d+), (\d+), (\d+), (\d+)\]\n(\d+) (\d+) (\d+) (\d+)\nAfter:\s+\[(\d+), (\d+), (\d+), (\d+)\]"#)
        let pieces = input.raw.components(separatedBy: "\n\n")
        let matches = r.matches(in: input.raw)
        return matches.map { m -> Change in
            return Change(before: [m.int(1)!, m.int(2)!, m.int(3)!, m.int(4)!],
                          instructions: [ m.int(5)!, m.int(6)!, m.int(7)!, m.int(8)!],
                          after: [m.int(9)!, m.int(10)!, m.int(11)!, m.int(12)!])
        }
    }()
    
    override func part1() -> String {
        var countAtLeast3 = 0
        
        for change in changes {
            let matchCount = Opcode.all.count { $0.matches(change) }
            if matchCount >= 3 { countAtLeast3 += 1 }
        }
        
        return "\(countAtLeast3)"
    }
    
    override func part2() -> String {
        var possibilities = Dictionary<Int, Set<Opcode>>()
        
        for change in changes {
            let op = change.instructions[0]
            let matches = Set(Opcode.all.filter { $0.matches(change) })
            if let ext = possibilities[op] {
                possibilities[op] = ext.intersection(matches)
            } else {
                possibilities[op] = matches
            }
        }
        
        var definitiveLookup = Dictionary<Int, Opcode>()
        var unsettled = Set(Opcode.all)
        for (code, poss) in possibilities {
            if poss.count == 1 {
                definitiveLookup[code] = poss.first!
                unsettled.remove(poss.first!)
            }
        }
        
        while unsettled.isNotEmpty {
            for i in 0 ..< Opcode.all.count {
                if definitiveLookup[i] == nil {
                    let choices = possibilities[i]!.intersection(unsettled)
                    if choices.count == 1 {
                        definitiveLookup[i] = choices.first!
                        unsettled.remove(choices.first!)
                    }
                }
            }
        }
        
        let rawInstructions = input.raw.components(separatedBy: "\n\n\n\n")[1]
        let instructions = Input(rawInstructions)
        
        var registers = [0, 0, 0, 0]
        for instruction in instructions.lines {
            let raw = instruction.words.integers
            let code = definitiveLookup[raw[0]]!
            code.execute(&registers, raw)
        }
        
        return "\(registers[0])"
    }
    
}
