//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/5/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Amp {
    
    private let intcode: Intcode
    private let inputs: LinkedList<Int>
    
    var isFinished: Bool { return intcode.isHalted }
    
    init(phase: Int, code: Array<Int>) {
        self.inputs = [phase]
        self.intcode = Intcode(memory: code)
    }
    
    func runP1(input: Int) -> Int {
        intcode.runUntilBeforeNextIO()
        intcode.io = inputs.first!
        intcode.step()
        intcode.io = input
        return intcode.run()
    }
    
    func runP2(input: Int) -> Int {
        inputs.append(input)
        
        var keepGoing = true
        while keepGoing {
            intcode.runUntilBeforeNextIO()
            if intcode.isHalted {
                keepGoing = false
            } else if intcode.needsIO() {
                // will read
                keepGoing = inputs.count > 0
                intcode.io = inputs.popFirst()
                if keepGoing {
                    intcode.step()
                    intcode.io = nil
                }
            } else {
                // will write
                intcode.step()
                keepGoing = false
            }
        }
        return intcode.io!
    }
    
}

class Day7: Day {
//
//    override init() {
//        super.init(rawInput: "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5")
//    }
    
    func part1() async throws -> String {
        var m = 0
        for n in (0...4).permutations() {
            var io = 0
            for phase in n {
                io = Amp(phase: phase, code: self.input().integers).runP1(input: io)
            }
            m = max(m, io)
        }
        
        return "\(m)"
    }
    
    func part2() async throws -> String {
        
        var m = 0
        for n in (5...9).permutations() {
            m = max(m, runAmpsInFeedbackMode(n))
        }
        
        return "\(m)"
    }
    
    private func runAmpsInFeedbackMode(_ phases: Array<Int>) -> Int {
        let a = Amp(phase: phases[0], code: input().integers)
        let b = Amp(phase: phases[1], code: input().integers)
        let c = Amp(phase: phases[2], code: input().integers)
        let d = Amp(phase: phases[3], code: input().integers)
        let e = Amp(phase: phases[4], code: input().integers)
        
        var eOutput = 0
        while e.isFinished == false {
            let aOutput = a.runP2(input: eOutput)
            let bOutput = b.runP2(input: aOutput)
            let cOutput = c.runP2(input: bOutput)
            let dOutput = d.runP2(input: cOutput)
            eOutput = e.runP2(input: dOutput)
        }
        return eOutput
    }
    
}
