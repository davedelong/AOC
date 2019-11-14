//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/17/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

public class Day18: Day {

    typealias Registers = Dictionary<String, Int>

    enum Instruction: CustomStringConvertible {
        enum Arg: CustomStringConvertible {
            case register(String)
            case value(Int)
            var description: String {
                switch self {
                    case .register(let s): return s
                    case .value(let i): return "\(i)"
                }
            }
            init(_ string: String) {
                if let i = Int(string) {
                    self = .value(i)
                } else {
                    self = .register(string)
                }
            }
            
            func eval(with registers: Registers) -> Int {
                switch self {
                    case .register(let r): return registers[r] ?? 0
                    case .value(let i): return i
                }
            }
        }
        
        case send(Arg)
        case set(String, Arg)
        case add(String, Arg)
        case mul(String, Arg)
        case mod(String, Arg)
        case receive(String)
        case jump(Arg, Arg)
        
        init(_ s: String) {
            self.init(args: s.components(separatedBy: .whitespaces))
        }
        
        init(args: Array<String>) {
            switch args[0] {
                case "snd": self = .send(Arg(args[1]))
                case "set": self = .set(args[1], Arg(args[2]))
                case "add": self = .add(args[1], Arg(args[2]))
                case "mul": self = .mul(args[1], Arg(args[2]))
                case "mod": self = .mod(args[1], Arg(args[2]))
                case "rcv": self = .receive(args[1])
                case "jgz": self = .jump(Arg(args[1]), Arg(args[2]))
                default: fatalError()
            }
        }
        
        var description: String {
            switch self {
                case .send(let a): return "snd \(a)"
                case .set(let r, let a): return "set \(r) \(a)"
                case .add(let r, let a): return "add \(r) \(a)"
                case .mul(let r, let a): return "mul \(r) \(a)"
                case .mod(let r, let a): return "mod \(r) \(a)"
                case .receive(let r): return "rcv \(r)"
                case .jump(let r, let a): return "jgz \(r) \(a)"
            }
        }
    }
    class Program {
        private var reg = Registers()
        private var rcv = Array<Int>()
        private let instructions: Array<Instruction>
        private var index = 0
        private let id: Int
        private let part1Logic: Bool
        
        enum Result {
            case ok
            case send(Int)
            case waiting
            case received(Int)
            
            var isWaiting: Bool {
                guard case .waiting = self else { return false }
                return true
            }
            
            var sending: Int? {
                guard case let .send(v) = self else { return nil }
                return v
            }
            
            var received: Int? {
                guard case let .received(v) = self else { return nil }
                return v
            }
        }
        
        init(id: Int, instructions: Array<Instruction>, part1Logic: Bool = false) {
            self.id = id
            self.instructions = instructions
            self.part1Logic = part1Logic
            reg["p"] = id
        }
        
        func step() -> Result {
            // return .waiting if we rcv but don't have a value
            guard index < instructions.count else { return .waiting }
            let inst = instructions[index]
            switch inst {
            case .send(let arg):
                index += 1
                if part1Logic == true {
                    receive(arg.eval(with: reg))
                }
                return .send(arg.eval(with: reg))
            case .set(let r, let arg):
                index += 1
                reg[r] = arg.eval(with: reg)
            case .add(let r, let arg):
                index += 1
                reg[r, default: 0] += arg.eval(with: reg)
            case .mul(let r, let arg):
                index += 1
                reg[r, default: 0] *= arg.eval(with: reg)
            case .mod(let r, let arg):
                index += 1
                reg[r, default: 0] %= arg.eval(with: reg)
            case .receive(let r):
                if part1Logic == true {
                    let argValue = Instruction.Arg.register(r).eval(with: reg)
                    index += 1
                    
                    if argValue > 0 {
                        return .received(rcv.first ?? 0)
                    }
                } else {
                    guard let next = rcv.popLast() else { return .waiting }
                    index += 1
                    reg[r] = next
                }
            case .jump(let r, let arg):
                let val = r.eval(with: reg)
                if val > 0 {
                    index += arg.eval(with: reg)
                } else {
                    index += 1
                }
            }
            return .ok
        }
        
        func receive(_ value: Int) {
            rcv.insert(value, at: 0)
        }
    }

    lazy var instructions: Array<Instruction> = {
        input.rawLineWords.map { Instruction(args: $0) }
    }()
    
    public init() { super.init(inputFile: #file) }

    override public func part1() -> String {
        let p1 = Program(id: 0, instructions: instructions, part1Logic: true)
        var received = 0
        while received <= 0 {
            let res = p1.step()
            received = res.received ?? 0
        }
        return "\(received)"
    }

    override public func part2() -> String {
        let p1 = Program(id: 1, instructions: instructions)
        let p2 = Program(id: 0, instructions: instructions)

        var p1Res = Program.Result.ok
        var p2Res = Program.Result.ok

        var p1SendCount = 0
        repeat {
            p1Res = p1.step()
            p2Res = p2.step()
    
            if let p1Send = p1Res.sending {
                p1SendCount += 1
                p2.receive(p1Send)
            }
            if let p2Send = p2Res.sending {
                p1.receive(p2Send)
            }
        } while !(p1Res.isWaiting && p2Res.isWaiting)

        return "\(p1SendCount)"
    }

}

}
