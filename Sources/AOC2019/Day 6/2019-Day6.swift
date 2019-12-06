//
//  Day6.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

fileprivate class Node: Hashable {
    static func ==(lhs: Node, rhs: Node) -> Bool { return lhs.value == rhs.value }
    
    let value: String
    var parent: Node?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    init(value: String) { self.value = value }
    
    var countToRoot: Int { return count(to: nil) }
    
    func count(to root: Node?) -> Int {
        var c = 0
        var p = parent
        while p != root {
            c += 1
            p = p?.parent
        }
        return c
    }
    
    var parents: UnfoldFirstSequence<Node> {
        return sequence(first: parent!, next: { $0.parent })
    }
}

class Day6: Day {
    
    override func run() -> (String, String) {
        let lines = input.lines
        
        var nodes = Dictionary<String, Node>()
        for line in lines {
            let parentName = String(line.raw.split(separator: ")")[0])
            let childName = String(line.raw.split(separator: ")")[1])
            
            let parentNode = nodes[parentName] ?? Node(value: parentName)
            let child = nodes[childName] ?? Node(value: childName)
            
            child.parent = parentNode
            nodes[parentName] = parentNode
            nodes[childName] = child
        }
        
        let countsToRoot = nodes.values.map { $0.countToRoot }
        let sum = countsToRoot.sum()
        
        let p1 = "\(sum)"
        
        let myNode = nodes["YOU"]!
        let santa = nodes["SAN"]!
        
        let myParents = Set(myNode.parents)
        let santaParents = santa.parents
        
        var commonRoot: Node?
        for sParent in santaParents {
            if myParents.contains(sParent) {
                commonRoot = sParent
                break
            }
        }
        
        let myCount = myNode.count(to: commonRoot)
        let santaCount = santa.count(to: commonRoot)
        
        
        
        let p2 = "\(myCount + santaCount)"
        
        return (p1, p2)
    }
    
}
