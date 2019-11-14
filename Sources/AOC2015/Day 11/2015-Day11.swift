//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/10/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day11: Day {
    
    @objc init() { super.init(inputSource: .raw("hepxcrrq")) }
    
    private let illegals = Set("iol")
    private let pairs = Regex(pattern: #"(.)\1.*(.)\2"#)
    
    private func isValid(_ password: String) -> Bool {
        if password.any(satisfy: { illegals.contains($0) }) { return false }
        if pairs.matches(password) == false { return false }
        for t in password.utf8.triples() {
            if t.0 + 1 == t.1 && t.1 + 1 == t.2 { return true }
        }
        
        return false
    }
    
    private func increment(_ password: String) -> String {
        // a = 97
        // z = 122
        var utf8 = Array(password.utf8.reversed())
        
        var carry: UInt8 = 1
        var column = 0
        while carry > 0 {
            utf8[column] += carry
            carry = 0
            while utf8[column] > 122 {
                carry += 1
                utf8[column] -= 26
            }
            column += 1
        }
        
        return String(bytes: utf8.reversed(), encoding: .utf8)!
    }
    
    override func part1() -> String {
        var current = input.raw
        while isValid(current) == false {
            current = increment(current)
        }
        return current
    }
    
    override func part2() -> String {
        var current = increment("hepxxyzz")
        while isValid(current) == false {
            current = increment(current)
        }
        return current
    }
    
}
