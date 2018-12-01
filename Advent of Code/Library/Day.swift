//
//  Day.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

protocol Year {
    var days: Array<Day> { get }
}

class Day {
    private let file: StaticString
    
    /// RAW
    
    lazy var rawInput: String = {
        var components = ("\(file)" as NSString).pathComponents
        _ = components.removeLast()
        components.append("input.txt")
        let path = NSString.path(withComponents: components)
        return try! String(contentsOf: URL(fileURLWithPath: path))
    }()
    
    lazy var rawInputCharacters: Array<Character> = {
        return Array(rawInput)
    }()
    
    lazy var rawInputIntegers: Array<Int> = {
        return rawInputCharacters.compactMap { Int("\($0)") }
    }()
    
    lazy var rawInputLines: Array<String> = {
        return rawInput.components(separatedBy: .newlines)
    }()
    
    lazy var rawInputLineCharacters: Array<Array<Character>> = {
        return rawInputLines.map { Array($0) }
    }()
    
    lazy var rawInputLineIntegers: Array<Int> = {
        return rawInputLines.compactMap { Int($0) }
    }()
    
    /// TRIMMED
    
    lazy var trimmedInput: String = {
        return rawInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }()
    
    lazy var trimmedInputCharacters: Array<Character> = {
        return Array(trimmedInput)
    }()
    
    lazy var trimmedInputIntegers: Array<Int> = {
        return trimmedInputCharacters.compactMap { Int("\($0)") }
    }()
    
    lazy var trimmedInputLines: Array<String> = {
        return trimmedInput.components(separatedBy: .newlines)
    }()
    
    lazy var trimmedInputLineCharacters: Array<Array<Character>> = {
        return trimmedInputLines.map { Array($0) }
    }()
    
    lazy var trimmedInputLineIntegers: Array<Int> = {
        return trimmedInputLines.compactMap { Int($0) }
    }()
    
    ///
    
    init(file: StaticString = #file) {
        self.file = file
    }
    
    func run() -> (String, String) {
        return (part1(), part2())
    }
    
    func part1() -> String { fatalError("Implement \(#function)") }
    func part2() -> String { fatalError("Implement \(#function)") }
}
