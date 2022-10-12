//
//  Day.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

public protocol Day {
    associatedtype Part1Result: CustomStringConvertible = String
    associatedtype Part2Result: CustomStringConvertible = String
    
    static var rawInput: String? { get }
    
    mutating func part1() async throws -> Part1Result
    mutating func part2() async throws -> Part2Result
    mutating func run() async throws -> (Part1Result, Part2Result)
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
    
    public mutating func part1() async throws -> Part1Result {
        fatalError("Implement \(#function)")
    }
    
    public mutating func part2() async throws -> Part2Result {
        fatalError("Implement \(#function)")
    }
    
    public mutating func run() async throws -> (Part1Result, Part2Result) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }
    
}

fileprivate let yearRegex = Regex(#"/AOC(\d+)/"#)
fileprivate let dayRegex = Regex(#".+?Day (\d+).+?\.txt$"#)
fileprivate let classNameRegex = Regex(#"AOC(\d+).Day(\d+)"#)

open class Day_OLD: NSObject {
    
    public static func day(for date: Date) -> Day_OLD {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return day(for: components.year ?? 0, month: components.month ?? 0, day: components.day ?? 0)
    }
    
    public static func day(for year: Int, month: Int, day: Int) -> Day_OLD {
        guard month == 12 else { return Bad() }
        return Year_OLD(year).day(day)
    }
    
    private static let inputFiles: Dictionary<Pair<Int>, String> = {
        let root = URL(fileURLWithPath: "\(#file)").deletingLastPathComponent().deletingLastPathComponent()
        let enumerator = FileManager.default.enumerator(at: root, includingPropertiesForKeys: nil)
        
        var files = Dictionary<Pair<Int>, String>()
        
        while let next = enumerator?.nextObject() as? URL {
            guard let year = yearRegex.firstMatch(in: next.path)?.int(1) else { continue }
            guard let day = dayRegex.firstMatch(in: next.path)?.int(1) else { continue }
            
            files[Pair(year, day)] = next.path
        }
        
        return files
    }()
    
    public let input: Input
    
    public init(rawInput: String) {
        self.input = Input(rawInput)
        super.init()
    }
    
    public override init() {
        let name = String(cString: class_getName(type(of: self)))
        
        if let match = classNameRegex.firstMatch(in: name), let year = match[int: 1], let day = match[int: 2], let file = Day_OLD.inputFiles[Pair(year, day)] {
            input = Input(file)
        } else {
            input = Input("")
        }
        super.init()
    }
    
    open func run() -> (String, String) {
        return autoreleasepool {
            let p1 = part1()
            let p2 = part2()
            return (p1, p2)
        }
    }
    open func part1() -> String { fatalError("Implement \(#function)") }
    open func part2() -> String { fatalError("Implement \(#function)") }
}

internal class Bad: Day_OLD {
    func run() async throws -> (String, String) {
        return ("Invalid day", "Invalid day")
    }
}
