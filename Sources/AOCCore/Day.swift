//
//  Day.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

fileprivate let yearRegex = Regex(pattern: #"/AOC(\d+)/"#)
fileprivate let dayRegex = Regex(pattern: #".+?Day (\d+).+?\.txt$"#)
fileprivate let classNameRegex = Regex(pattern: #"AOC(\d+).Day(\d+)"#)

open class Day: NSObject {
    
    private static let inputFiles: Dictionary<Pair<Int>, String> = {
        let root = URL(fileURLWithPath: "\(#file)").deletingLastPathComponent().deletingLastPathComponent()
        let enumerator = FileManager.default.enumerator(at: root, includingPropertiesForKeys: nil)
        
        var files = Dictionary<Pair<Int>, String>()
        
        while let next = enumerator?.nextObject() as? URL {
            guard let year = yearRegex.match(next.path)?.int(1) else { continue }
            guard let day = dayRegex.match(next.path)?.int(1) else { continue }
            
            files[Pair(year, day)] = next.path
            print("Found \(year)-\(day) -> \(next.path)")
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
        let match = name.match(classNameRegex)
        let year = match.int(1)!
        let day = match.int(2)!
        
        if let onDiskInputFile = Day.inputFiles[Pair(year, day)] {
            self.input = Input(file: onDiskInputFile)
        } else {
            self.input = Input("")
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
