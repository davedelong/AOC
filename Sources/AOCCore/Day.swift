//
//  Day.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

fileprivate let yearRegex = Regex(#"/AOC(\d+)/"#)
fileprivate let dayRegex = Regex(#".+?Day (\d+).+?\.txt$"#)
fileprivate let classNameRegex = Regex(#"AOC(\d+).Day(\d+)"#)

open class Day: NSObject {
    
    public static func day(for date: Date) -> Day {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return day(for: components.year ?? 0, month: components.month ?? 0, day: components.day ?? 0)
    }
    
    public static func day(for year: Int, month: Int, day: Int) -> Day {
        guard month == 12 else { return Bad() }
        return Year(year).day(day)
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
        
        if let match = classNameRegex.firstMatch(in: name), let year = match[int: 1], let day = match[int: 2], let file = Day.inputFiles[Pair(year, day)] {
            input = Input(file: file)
        } else {
            input = Input("")
        }
        super.init()
    }
    
    open func run() -> (String, String) {
        return autoreleasepool {
            (part1(), part2())
        }
    }
    open func part1() -> String { fatalError("Implement \(#function)") }
    open func part2() -> String { fatalError("Implement \(#function)") }
}

internal class Bad: Day {
    override func run() -> (String, String) {
        return ("Invalid day", "Invalid day")
    }
}
