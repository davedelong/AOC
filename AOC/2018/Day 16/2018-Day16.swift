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

extension Year2018 {
    
    public class Day16: Day {
        
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
                var new = regs
                new[inst[C]] = regs[inst[A]] + regs[inst[B]]
                return new
            }
            static let addi = Opcode(name: "addi") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]] + inst[B]
                return new
            }
            static let mulr = Opcode(name: "mulr") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]] * regs[inst[B]]
                return new
            }
            static let muli = Opcode(name: "muli") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]] * inst[B]
                return new
            }
            static let banr = Opcode(name: "banr") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]] & regs[inst[B]]
                return new
            }
            static let bani = Opcode(name: "bani") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]] & inst[B]
                return new
            }
            static let borr = Opcode(name: "borr") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]] | regs[inst[B]]
                return new
            }
            static let bori = Opcode(name: "bori") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]] | inst[B]
                return new
            }
            static let setr = Opcode(name: "setr") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]]
                return new
            }
            static let seti = Opcode(name: "seti") { (regs, inst) in
                var new = regs
                new[inst[C]] = inst[A]
                return new
            }
            static let gtir = Opcode(name: "gtir") { (regs, inst) in
                var new = regs
                new[inst[C]] = inst[A] > regs[inst[B]] ? 1 : 0
                return new
            }
            static let gtri = Opcode(name: "gtri") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]] > inst[B] ? 1 : 0
                return new
            }
            static let gtrr = Opcode(name: "gtrr") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]] > regs[inst[B]] ? 1 : 0
                return new
            }
            static let eqir = Opcode(name: "eqir") { (regs, inst) in
                var new = regs
                new[inst[C]] = inst[A] == regs[inst[B]] ? 1 : 0
                return new
            }
            static let eqri = Opcode(name: "eqri") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]] == inst[B] ? 1 : 0
                return new
            }
            static let eqrr = Opcode(name: "eqrr") { (regs, inst) in
                var new = regs
                new[inst[C]] = regs[inst[A]] == regs[inst[B]] ? 1 : 0
                return new
            }
            
            static func ==(lhs: Opcode, rhs: Opcode) -> Bool {
                return lhs.name == rhs.name
            }
            
            let name: String
            let execute: (Registers, Array<Int>) -> Registers
            var hashValue: Int { return name.hashValue }
            
            func matches(_ change: Change) -> Bool {
                let produced = execute(change.before, change.instructions)
                return produced == change.after
            }
        }
        
        struct Change {
            let before: Registers
            let instructions: Array<Int>
            let after: Registers
        }
        
        public init() { super.init(inputSource: .file(#file)) }
        
        lazy var changes: Array<Change> = {
            let r = Regex(pattern: "Before:\\s+\\[(\\d+), (\\d+), (\\d+), (\\d+)\\]\\n(\\d+) (\\d+) (\\d+) (\\d+)\\nAfter:\\s+\\[(\\d+), (\\d+), (\\d+), (\\d+)\\]")
            let pieces = input.raw.components(separatedBy: "\n\n")
            let matches = r.matches(in: input.raw)
            return matches.map { m -> Change in
                return Change(before: [Int(m[1]!)!, Int(m[2]!)!, Int(m[3]!)!, Int(m[4]!)!],
                              instructions: [ Int(m[5]!)!, Int(m[6]!)!, Int(m[7]!)!, Int(m[8]!)! ],
                              after: [Int(m[9]!)!, Int(m[10]!)!, Int(m[11]!)!, Int(m[12]!)!])
            }
        }()
        
        override public func part1() -> String {
            var countAtLeast3 = 0
            
            for change in changes {
                let matchCount = Opcode.all.count { $0.matches(change) }
                if matchCount >= 3 { countAtLeast3 += 1 }
            }
            
            return "\(countAtLeast3)"
        }
        
        override public func part2() -> String {
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
            
            while unsettled.isEmpty == false {
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
                registers = code.execute(registers, raw)
            }
            
            return "\(registers[0])"
        }
        
    }
    
}
