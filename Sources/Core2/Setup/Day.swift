//
//  File.swift
//  
//
//  Created by Dave DeLong on 10/12/22.
//

import Foundation

public protocol Day {
    associatedtype Part1Result: CustomStringConvertible = String
    associatedtype Part2Result: CustomStringConvertible = String
    
    static var rawInput: String? { get }
    
    func part1() async throws -> Part1Result
    func part2() async throws -> Part2Result
    func run() async throws -> (Part1Result, Part2Result)
}

extension Day {
    public static var rawInput: String? { nil }
    
    public static func makeInput(_ file: StaticString = #file) -> Input {
        if let raw = self.rawInput {
            return Input(raw)
        } else {
            return Input.makeInput(caller: file)
        }
    }
    
    public func part1() async throws -> Part1Result {
        fatalError("Implement \(#function)")
    }
    
    public func part2() async throws -> Part2Result {
        fatalError("Implement \(#function)")
    }
    
    public func run() async throws -> (Part1Result, Part2Result) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }
    
}
