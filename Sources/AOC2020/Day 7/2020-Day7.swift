//
//  Day7.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day7: Day {
    
    class Bag: Hashable {
        static func ==(lhs: Bag, rhs: Bag) -> Bool { lhs.name == rhs.name }
        func hash(into hasher: inout Hasher) { hasher.combine(name) }
        
        private var parents = Set<Bag>()
        private var children = Dictionary<Bag, Int>()
        
        var totalCount: Int { children.reduce(into: 0) { $0 += (($1.key.totalCount + 1) * $1.value) } }
        var allParents: Set<Bag> { Set(parents + parents.flatMap(\.allParents)) }
        
        let name: String
        init(name: String) { self.name = name }
        
        func addBag(_ other: Bag, count: Int) {
            other.parents.insert(self)
            children[other, default: 0] += count
        }

    }
    
    override func run() -> (String, String) {
        let nameRegex: Regex = #"^(.+?) bags?"#
        let bagRegex: Regex = #"(\d+) (.+?) bags?"#
        
        var nodes = Dictionary<String, Bag>()
        for line in input.rawLines {
            let name = nameRegex.firstMatch(in: line)![1]!
            let nameNode = nodes[name, inserting: Bag(name: name)]
            
            for match in bagRegex.matches(in: line) {
                let contained = nodes[match[2]!, inserting: Bag(name: match[2]!)]
                nameNode.addBag(contained, count: match[int: 1]!)
            }
        }
        
        let target = nodes["shiny gold"]!
        
        let p1 = target.allParents.count
        let p2 = target.totalCount
        return ("\(p1)", "\(p2)")
    }

}
