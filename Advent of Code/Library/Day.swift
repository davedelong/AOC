//
//  Day.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

protocol Day {
    init()
    func run()
    
    func part1()
    func part2()
    
}

extension Day {
    
    static func rawInput(_ callingFrom: StaticString = #file) -> String {
        var components = ("\(callingFrom)" as NSString).pathComponents
        _ = components.removeLast()
        components.append("input.txt")
        let path = NSString.path(withComponents: components)
        return try! String(contentsOf: URL(fileURLWithPath: path))
    }
    
    static func trimmedInput(_ callingFrom: StaticString = #file) -> String {
        return rawInput(callingFrom).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func inputLines(trimming: Bool = true, _ callingFrom: StaticString = #file) -> Array<String> {
        let i = trimming ? trimmedInput(callingFrom) : rawInput(callingFrom)
        return i.components(separatedBy: .newlines)
    }
    
    static func inputCharacters(trimming: Bool = true, _ callingFrom: StaticString = #file) -> Array<Array<Character>> {
        return inputLines(trimming: trimming, callingFrom).map { Array($0) }
    }
    
    func run() {
        part1()
        part2()
    }
    func part1() { print("part 1: implement me!") }
    func part2() { print("part 2: implement me!") }
    
}
