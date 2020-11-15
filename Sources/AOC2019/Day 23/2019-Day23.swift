//
//  Day23.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

fileprivate class Computer {
    
    private let intcode: Intcode
    let input = LinkedList<Int>()
    
    private var pendingOutput: (Int?, Int?) = (nil, nil)
    
    init(address: Int, code: Array<Int>) {
        intcode = Intcode(memory: code)
        input.append(address)
    }
    
    func runForAWhile() -> (Int, Int, Int)? {
//        intcode.runUntilBeforeNextIO()
        return nil
    }
    
}

class Day23: Day {
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    override func part1() -> String {
        
        let inputs = (0 ..< 50).map { idx -> LinkedList<Int> in
            let l = LinkedList<Int>()
            l.append(idx)
            return l
        }
        
        var p2: Int?
        
        let computers = (0..<50).map { _ in return Intcode(memory: input.integers) }
        
        var currentComputer = 0
        
        while p2 == nil {
            let c = computers[currentComputer]
            c.runUntilBeforeNextIO()
            if c.isHalted {
                currentComputer += 1
            } else if c.needsIO() {
                // get io
            } else {
                // has output
            }
        }
        
        return "\(p2!)"
    }
    
    override func part2() -> String {
        return #function
    }
    
}
