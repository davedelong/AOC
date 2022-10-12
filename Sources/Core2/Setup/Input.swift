//
//  File.swift
//  
//
//  Created by Dave DeLong on 10/12/22.
//

import Foundation


public protocol StringInput {
    init(_ raw: String)
    var raw: String { get }
    var integer: Int? { get }
    var characters: Array<Character> { get }
    var digits: Array<Int> { get } // digit is 0 ... 9
    
    var trimmed: Self { get }
    var lines: Array<Line> { get }
    var words: Array<Word> { get }
    var csvWords: Array<Word> { get }
    var bits: Array<Bit> { get }
    func words(separatedBy: CharacterSet) -> Array<Word>
    func words(separatedBy: String) -> Array<Word>
}

public final class Input: StringInput {
    
    private static var inputs = Dictionary<String, Input>()
    
    internal static func makeInput(caller: StaticString) -> Input {
        if let e = inputs[caller.description] { return e }
        
        var path = caller.description.pathComponents
        if path.last?.hasSuffix(".swift") == true {
            path.removeLast()
        }
        
        // look for an "input.txt" file
        path.append("input.txt")
        
        let inputTxtPath = path.joined(by: "/")
        if let str = try? String(contentsOfFile: inputTxtPath) {
            let input = Input(str)
            inputs[caller.description] = input
            return input
        }
        
        // pop input.txt
        path.removeLast()
        
        if path.last?.hasPrefix("Day ") == true {
            path.removeLast() // pop the "Day N" folder
        }
        
        path.append("Resources")
        
        return .init()
    }
    
    public convenience init(file: String) { self.init(try! String(contentsOfFile: file)) }
    public init(_ raw: String) { self.raw = raw.trimmingCharacters(in: .newlines) }
    
    public let raw: String
    public lazy var integer: Int? = { Int(raw) }()
    public lazy var characters: Array<Character> = { Array(raw) }()
    public lazy var digits: Array<Int> = { raw.compactMap(\.wholeNumberValue) }()
    public lazy var bits: Array<Bit> = { raw.compactMap(\.bitValue) }()
    
    public lazy var trimmed: Input = { Input(raw.trimmingCharacters(in: .whitespacesAndNewlines)) }()
    public lazy var lines: Array<Line> = { return raw.components(separatedBy: .newlines).map { Line($0) } }()
    public lazy var words: Array<Word> = { return self.words(separatedBy: .whitespaces) }()
    public lazy var csvWords: Array<Word> = { return self.words(separatedBy: .comma) }()
    public lazy var integers: Array<Int> = {
        let matches = Regex.integers.matches(in: raw)
        return matches.compactMap { $0.int(1) }
    }()
    
    public func words(separatedBy: CharacterSet) -> Array<Word> {
        return raw.components(separatedBy: separatedBy).filter { $0.isNotEmpty }.map { Word($0) }
    }
    
    public func words(separatedBy: String) -> Array<Word> {
        return raw.components(separatedBy: separatedBy).filter { $0.isNotEmpty }.map { Word($0) }
    }
    
    public lazy var rawLines: Array<String> = { lines.raw }()
    public lazy var rawWords: Array<String> = { words.raw }()
    public lazy var rawLineWords: Array<Array<String>> = { lines.words.raw }()
}

public final class Line: StringInput {
    public init(_ raw: String) { self.raw = raw }
    
    public let raw: String
    public lazy var integer: Int? = { Int(raw) }()
    public lazy var characters: Array<Character> = { Array(raw) }()
    public lazy var digits: Array<Int> = { raw.compactMap(\.wholeNumberValue) }()
    public lazy var bits: Array<Bit> = { raw.compactMap(\.bitValue) }()
    
    public lazy var trimmed: Line = { Line(raw.trimmingCharacters(in: .whitespacesAndNewlines)) }()
    public var lines: Array<Line> { return [self] }
    public lazy var words: Array<Word> = { return self.words(separatedBy: .whitespaces) }()
    public lazy var csvWords: Array<Word> = { return self.words(separatedBy: .comma) }()
    
    public lazy var integers: Array<Int> = {
        let matches = Regex.integers.matches(in: raw)
        return matches.compactMap { $0.int(1) }
    }()
    
    public func words(separatedBy: CharacterSet) -> Array<Word> {
        return raw.components(separatedBy: separatedBy).filter { $0.isNotEmpty }.map { Word($0) }
    }
    
    public func words(separatedBy: String) -> Array<Word> {
        return raw.components(separatedBy: separatedBy).filter { $0.isNotEmpty }.map { Word($0) }
    }
}

public final class Word: StringInput {
    public init(_ raw: String) { self.raw = raw }
    
    public let raw: String
    public lazy var integer: Int? = { Int(raw) }()
    public lazy var characters: Array<Character> = { Array(raw) }()
    public lazy var digits: Array<Int> = { raw.compactMap(\.wholeNumberValue) }()
    public lazy var bits: Array<Bit> = { raw.compactMap(\.bitValue) }()
    
    public lazy var trimmed: Word = { Word(raw.trimmingCharacters(in: .whitespacesAndNewlines)) }()
    public lazy var lines: Array<Line> = { return [Line(raw)] }()
    public var words: Array<Word> { return [self] }
    public var csvWords: Array<Word> { return [self] }
    public func words(separatedBy: CharacterSet) -> Array<Word> { return [self] }
    public func words(separatedBy: String) -> Array<Word> { return [self] }
}

extension Collection where Element: StringInput {
    public var raw: Array<String> { return map { $0.raw } }
    public var integers: Array<Int> { return map { $0.integer! } }
    public var characters: Array<Array<Character>> { return map { $0.characters } }
    public var digits: Array<Array<Int>> { return map { $0.digits } }
    public var bits: Array<Array<Bit>> { map { $0.bits } }
    
    public var trimmed: Array<Element> { return map { $0.trimmed } }
    public var lines: Array<Array<Line>> { return map { $0.lines } }
    public var words: Array<Array<Word>> { return map { $0.words } }
    public var rawWords: Array<Array<String>> { map { $0.words.raw } }
    public var csvWords: Array<Array<Word>> { return map { $0.csvWords } }
    public func words(separatedBy: CharacterSet) -> Array<Array<Word>> {
        return map { $0.words(separatedBy: separatedBy) }
    }
    public func words(separatedBy: String) -> Array<Array<Word>> {
        return map { $0.words(separatedBy: separatedBy) }
    }
}

extension Collection where Element: Collection, Element.Element: StringInput {
    public var raw: Array<Array<String>> { return map { $0.raw } }
    public var integers: Array<Array<Int>> { return map { $0.integers } }
}

extension Collection where Element == Character {
    public var integers: Array<Int> { compactMap(\.wholeNumberValue) }
    public var bits: Array<Bit> { compactMap(\.bitValue) }
}
