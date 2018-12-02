//
//  Day.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

@_exported import Foundation
@_exported import GameplayKit

public protocol Year {
    var days: Array<Day> { get }
}

public class Day {
    public enum InputSource {
        case none
        case raw(String)
        case file(StaticString)
    }
    
    public let input: Input
    
    public init(inputSource: InputSource = .none) {
        switch inputSource {
            case .none:
                input = Input("")
            case .raw(let s):
                input = Input(s)
            case .file(let f):
                var components = ("\(f)" as NSString).pathComponents
                _ = components.removeLast()
                components.append("input.txt")
                let path = NSString.path(withComponents: components)
                input = Input(file: path)
        }
    }
    
    public func run() -> (String, String) {
        return (part1(), part2())
    }
    
    public func part1() -> String { fatalError("Implement \(#function)") }
    public func part2() -> String { fatalError("Implement \(#function)") }
}
