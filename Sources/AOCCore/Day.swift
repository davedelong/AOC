//
//  Day.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

public protocol Day {
    associatedtype Part1: CustomStringConvertible = String
    associatedtype Part2: CustomStringConvertible = String
    
    static var rawInput: String? { get }
    
    func part1() async throws -> Part1
    func part2() async throws -> Part2
    func run() async throws -> (Part1, Part2)
}

extension Day {
    public static var rawInput: String? { nil }
    
    public func input(_ file: StaticString = #file) -> Input {
        if let raw = Self.rawInput {
            return Input(raw)
        } else {
            return Input.makeInput(caller: file)
        }
    }
    
    public func part1() async throws -> Part1 {
        fatalError("Implement \(#function)")
    }
    
    public func part2() async throws -> Part2 {
        fatalError("Implement \(#function)")
    }
    
    public func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }
    
}
