//
//  Day25.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day25: Day {
    
    struct TuringState {
        let ifOne: (Int, Int, String)
        let ifZero: (Int, Int, String)
        func actions(for: Int) -> (Int, Int, String) {
            return `for` == 0 ? ifZero : ifOne
        }
    }
    
    enum State {
        case A
        case B
        case C
        case D
        case E
        case F
    }
    
    var startingState: String = ""
    var iterations: Int = 0
    var states = Dictionary<String, TuringState>()
    
    init() {
        let begin = Regex(#"Begin in state ([A-Z])\."#)
        let steps = Regex(#"Perform a diagnostic checksum after (\d+) steps\."#)
        
        let name = Regex(#"\s*In state ([A-Z])\:"#)
        let write = Regex(#"\s*- Write the value (\d)\."#)
        let move = Regex(#"\s*- Move one slot to the (left|right)\."#)
        let state = Regex(#"\s*- Continue with state ([A-Z])\."#)
        
        var sections = input().raw.components(separatedBy: "\n\n")
        
        let metaInfo = sections.removeFirst()
        let metaLines = metaInfo.components(separatedBy: .newlines)
        
        startingState = begin.firstMatch(in: metaLines[0])![1]!
        iterations = steps.firstMatch(in: metaLines[1])!.int(1)!
        
        sections.forEach { section in
            let lines = section.components(separatedBy: .newlines)
            
            let n = name.firstMatch(in: lines[0])![1]!
            let zeroWrite = write.firstMatch(in: lines[2])!.int(1)!
            let zeroMove = (move.firstMatch(in: lines[3])![1] == "left") ? -1 : 1
            let zeroState = state.firstMatch(in: lines[4])![1]!
            
            let oneWrite = write.firstMatch(in: lines[6])!.int(1)!
            let oneMove = (move.firstMatch(in: lines[7])![1] == "left") ? -1 : 1
            let oneState = state.firstMatch(in: lines[8])![1]!
            
            let s = TuringState(ifOne: (oneWrite, oneMove, oneState), ifZero: (zeroWrite, zeroMove, zeroState))
            states[n] = s
        }
        
        
    }
    
    func part1() async throws -> String {
        var tape = Dictionary<Int, Int>()
        var cursor = 0
        var state = State.A
        
        for _ in 0 ..< 12302209 {
            
            let currentValue = tape[cursor] ?? 0
            switch state {
                case .A:
                    if currentValue == 0 {
                        tape[cursor] = 1
                        cursor += 1
                        state = .B
                    } else {
                        tape[cursor] = 0
                        cursor -= 1
                        state = .D
                    }
                case .B:
                    if currentValue == 0 {
                        tape[cursor] = 1
                        cursor += 1
                        state = .C
                    } else {
                        tape[cursor] = 0
                        cursor += 1
                        state = .F
                    }
                case .C:
                    if currentValue == 0 {
                        tape[cursor] = 1
                        cursor -= 1
                        state = .C
                    } else {
                        tape[cursor] = 1
                        cursor -= 1
                        state = .A
                    }
                case .D:
                    if currentValue == 0 {
                        tape[cursor] = 0
                        cursor -= 1
                        state = .E
                    } else {
                        tape[cursor] = 1
                        cursor += 1
                        state = .A
                    }
                case .E:
                    if currentValue == 0 {
                        tape[cursor] = 1
                        cursor -= 1
                        state = .A
                    } else {
                        tape[cursor] = 0
                        cursor += 1
                        state = .B
                    }
                case .F:
                    if currentValue == 0 {
                        tape[cursor] = 0
                        cursor += 1
                        state = .C
                    } else {
                        tape[cursor] = 0
                        cursor += 1
                        state = .E
                    }
                
            }
            
        }
        
        let checksum = tape.values.sum
        
        return "\(checksum)"
    }
    
    func part2() async throws -> String {
        var tape = Dictionary<Int, Int>()
        var cursor = 0
        var current = startingState
        
        for _ in 0 ..< iterations {
            let value = tape[cursor] ?? 0
            let actions = states[current]!.actions(for: value)
            tape[cursor] = actions.0
            cursor += actions.1
            current = actions.2
        }
        
        let checksum = tape.values.sum
        return "\(checksum)"
    }
    
}
