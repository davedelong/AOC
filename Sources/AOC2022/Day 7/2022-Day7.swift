//
//  Day7.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day7: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    enum Entry {
        case folder(String)
        case file(String, Int)
        
        var name: String {
            switch self {
                case .folder(let n): return n
                case .file(let n, _): return n
            }
        }
        
    }

    func run() async throws -> (Part1, Part2) {
        
        let root = Node(value: Entry.folder("/"))
        
        var current = root
        for line in input().lines.raw.dropFirst() {
            if line.hasPrefix("$ cd ") {
                let folder = line.dropFirst(5)
                if folder == ".." {
                    current = current.parent!
                } else {
                    current = current.children.first(where: { $0.value.name == String(folder) })!
                }
            } else if line.hasPrefix("$ ls") {
                // starting to list
            } else if line.hasPrefix("dir ") {
                let name = line.dropFirst(4)
                current.addChild(.init(value: .folder(String(name))))
            } else {
                let pieces = line.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: false)
                let size = Int(pieces[0])!
                let name = pieces[1]
                current.addChild(.init(value: .file(String(name), size)))
            }
        }
        
        let directories = root.collectAll(where: \.isDirectory)
        let p1 = directories.filter { $0.size <= 100000 }.sum(of: \.size)
        
        let usedSpace = root.size
        let totalSpace = 70000000
        let unusedSpace = totalSpace - usedSpace
        
        let neededSpace = 30000000 - unusedSpace
        
        let p2 = directories.filter { $0.size >= neededSpace }.min(by: { $0.size < $1.size })!.size
        
        return (p1, p2)
    }

}

extension Node where T == Day7.Entry {
    
    var isDirectory: Bool {
        if case .folder = value { return true }
        return false
    }
    
    var size: Int {
        switch value {
            case .file(_, let size): return size
            case .folder:
                return children.map(\.size).sum
        }
    }
    
}
