//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/19/21.
//

import Foundation

protocol AOCDay {
    associatedtype Part1Result: CustomStringConvertible, Equatable = String
    associatedtype Part2Result: CustomStringConvertible, Equatable = String
    
    func part1() -> Part1Result
    func part2() -> Part2Result
    func run() -> (Part1Result, Part2Result)
}

extension AOCDay where Part1Result == String {
    func part1() -> Part1Result { fatalError() }
}

extension AOCDay where Part2Result == String {
    func part2() -> Part2Result { fatalError() }
}

extension AOCDay {
    func run() -> (Part1Result, Part2Result) {
        return autoreleasepool {
            let p1 = part1()
            let p2 = part2()
            return (p1, p2)
        }
    }
}

struct AOC2021_Day1: AOCDay {
    
}
