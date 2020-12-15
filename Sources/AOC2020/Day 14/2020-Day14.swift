//
//  Day14.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day14: Day {

    override func run() -> (String, String) {
        return super.run()
    }

    let maskR: Regex = #"mask = ([10X]+)"#
    let assignR: Regex = #"mem\[(\d+)\] = (\d+)"#
    
    override func part1() -> String {
        enum Op {
            case mask(ones: Int, zeros: Int)
            case assign(Int, Int)
        }
        
        let ops = input.rawLines.map { line -> Op in
            if let m = maskR.match(line) {
                let line = m[1]!
                let ones = Int(bits: line.map { $0 == "1" })
                let zeros = Int(bits: line.map { $0 == "0" })
                return .mask(ones: ones, zeros: zeros)
            } else if let m = assignR.match(line) {
                return .assign(m[int: 1]!, m[int: 2]!)
            } else {
                fatalError()
            }
        }
        
        var memory = Sparse<Int>([], default: 0)
        
        var oneMask = 0
        var zeroMask = 0
        for op in ops {
            if case .mask(let o, let z) = op {
                oneMask = o
                zeroMask = z
            } else if case .assign(let slot, let value) = op {
                memory[slot] = (value | oneMask) & ~zeroMask
            }
        }
        
        return "\(memory.sum)"
    }

    override func part2() -> String {
        enum Op {
            case mask(Array<Bool?>)
            case assign(Int, Int)
        }
        
        let ops = input.rawLines.map { line -> Op in
            if let m = maskR.match(line) {
                let line = m[1]!
                return .mask(line.map { $0 == "1" ? true : ($0 == "0" ? false : nil) })
            } else if let m = assignR.match(line) {
                return .assign(m[int: 1]!, m[int: 2]!)
            } else {
                fatalError()
            }
        }
        
        var memory = Sparse<Int>([], default: 0)
        
        var mask: Array<Bool?> = []
        for op in ops {
            if case .mask(let bits) = op {
                mask = bits
            } else if case .assign(let slot, let value) = op {
                let addresses = applyMask(input: slot, mask: mask)
                for addr in addresses {
                    memory[addr] = value
                }
            }
        }
        
        return "\(memory.sum)"
    }

    func applyMask(input: Int, mask: Array<Bool?>) -> Array<Int> {
        let twiddled = Array(zip(input.bits.reversed(), mask.reversed()).map { (b, m) -> Bool? in
            if m == false { return b }
            if m == true { return true }
            return nil
        }.reversed())
        
        return recursivelyTwiddle(twiddled)
    }
    
    private func recursivelyTwiddle(_ bits: Array<Bool?>) -> Array<Int> {
        var answer = Array<Int>()
        if let i = bits.firstIndex(of: nil) {
            var copy = bits
            copy[i] = true
            answer.append(contentsOf: recursivelyTwiddle(copy))
            copy[i] = false
            answer.append(contentsOf: recursivelyTwiddle(copy))
        } else {
            answer.append(Int(bits: bits.compacted))
        }
        return answer
    }
}
