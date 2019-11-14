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

open class Day {
    public enum InputSource {
        case none
        case raw(String)
        case file(StaticString)
    }
    
    private let source: InputSource
    
    public lazy var input: Input = {
        switch source {
            case .none:
                fatalError("Cannot access input when none was provided")
            case .raw(let s):
                return Input(s)
            case .file(let f):
                var components = ("\(f)" as NSString).pathComponents
                _ = components.removeLast()
                components.append("input.txt")
                let path = NSString.path(withComponents: components)
                return Input(file: path)
        }
    }()
    
    public init(inputSource: InputSource = .none) {
        self.source = inputSource
    }
    
    open func run() -> (String, String) { return (part1(), part2()) }
    open func part1() -> String { fatalError("Implement \(#function)") }
    open func part2() -> String { fatalError("Implement \(#function)") }
}
