//
//  Input.swift
//  Advent of Code
//
//  Created by Dave DeLong on 12/1/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public var authenticationToken: String?

extension CharacterSet {
    public static var comma = CharacterSet(charactersIn: ",")
}

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

extension StringInput {
    
    public var isEmpty: Bool { raw.isEmpty }
    public var isNotEmpty: Bool { raw.isNotEmpty }
    
}

public final class Input: StringInput {
    
    private static let yearNumber = Regex(#"AOC(\d{4})"#)
    private static let dayNumber = Regex(#"[dD]ay ?(\d{1,2})"#)
    
    private static var inputs = Dictionary<String, Input>()
    
    internal static func makeInput(caller: StaticString) -> Input {
        if let e = inputs[caller.description] { return e }
        
        var path = caller.description.split(separator: "/")
        
        let year = path.compactMap { yearNumber.firstMatch(in: $0)?.int(1) }.first ?? 0
        let day = path.compactMap { dayNumber.firstMatch(in: $0)?.int(1) }.first ?? 0
        
        if path.last?.hasSuffix(".swift") == true { path.removeLast() }
        
        // look for an "input.txt" file
        path.append("input.txt")
        
        let inputTxtPath = "/" + path.joined(separator: "/")
        if FileManager.default.fileExists(atPath: inputTxtPath), let str = (try? String(contentsOfFile: inputTxtPath)), str.isEmpty == false {
            let input = Input(str)
            inputs[caller.description] = input
            return input
        }
        
        // input file does not exist or it's blank; try falling back
        
        // try to download it
        if let token = authenticationToken,
           let url = URL(string: "https://adventofcode.com/\(year)/day/\(day)/input"),
           let cookie = HTTPCookie(properties: [.path: "/", .name: "session", .domain: "adventofcode.com", .value: token]) {
            
            URLSession.shared.configuration.httpCookieStorage?.setCookie(cookie)
            
            do {
                let str = try String(contentsOf: url)
                try str.write(toFile: inputTxtPath, atomically: true, encoding: .utf8)
                
                let input = Input(str)
                inputs[caller.description] = input
                return input
            } catch {
                print("Error: \(error)")
            }
        }
        
        // pop input.txt
        path.removeLast()
        
        if path.last?.hasPrefix("Day ") == true {
            path.removeLast() // pop the "Day N" folder
        }
        
        path.append("Resources")
        // look in a resources folder
        
        return .init("")
    }
    
    private init(file: String) {
        self.url = URL(fileURLWithPath: file)
        self.raw = (try! String(contentsOfFile: file)).trimmingCharacters(in: .newlines)
    }
    
    public init(_ raw: String) {
        self.raw = raw.trimmingCharacters(in: .newlines)
        self.url = nil
    }
    
    public let url: URL?
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
    public var raw: Array<String> { map(\.raw) }
    public var integers: Array<Int> { compactMap(\.integer) }
    public var characters: Array<Array<Character>> { map(\.characters) }
    public var digits: Array<Array<Int>> { map(\.digits) }
    public var bits: Array<Array<Bit>> { map(\.bits) }
    
    public var trimmed: Array<Element> { map(\.trimmed) }
    public var lines: Array<Array<Line>> { map(\.lines) }
    public var words: Array<Array<Word>> { map(\.words) }
    public var csvWords: Array<Array<Word>> { map(\.csvWords) }
    public func words(separatedBy: CharacterSet) -> Array<Array<Word>> {
        return map { $0.words(separatedBy: separatedBy) }
    }
    public func words(separatedBy: String) -> Array<Array<Word>> {
        return map { $0.words(separatedBy: separatedBy) }
    }
}

extension Collection where Element: Collection, Element.Element: StringInput {
    public var raw: Array<Array<String>> { return map(\.raw) }
    public var integers: Array<Array<Int>> { return map(\.integers) }
}

extension Collection where Element == Character {
    public var integers: Array<Int> { compactMap(\.wholeNumberValue) }
    public var bits: Array<Bit> { compactMap(\.bitValue) }
}
