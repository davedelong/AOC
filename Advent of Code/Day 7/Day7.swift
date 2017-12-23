//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/5/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import GameplayKit

class Day7: Day {

    class Node: Hashable {
        static func ==(lhs: Node, rhs: Node) -> Bool { return lhs.name == rhs.name }
        let name: String
        var hashValue: Int { return name.hashValue }
        weak var parent: Node?
        var children = Array<Node>()
        
        let weight: Int
        var computedWeight = 0
        
        init(_ n: String, weight: Int) {
            name = n
            self.weight = weight
        }
        
        func add(child: Node) {
            children.append(child)
            child.parent = self
        }
        
        func computeWeights() {
            children.forEach { $0.computeWeights() }
            computedWeight = weight + children.reduce(0) { $0 + $1.computedWeight }
        }
        
        func imbalancedChild() -> Node? {
            let childrenByWeight = Dictionary(grouping: children, by: { $0.computedWeight })
            if childrenByWeight.keys.count < 2 { return nil }
            let imbalancedNodes = childrenByWeight.filter { $0.value.count == 1 }
            
            let imbalancedNode = imbalancedNodes[imbalancedNodes.keys.first!]![0]
            return imbalancedNode.imbalancedChild() ?? imbalancedNode
        }
    }

    required init() { }

    func makeTree() -> Node? {
        let lines = Day7.inputLines()
        
        let regex = try! NSRegularExpression(pattern: "^([^ ]+) \\((\\d+)\\)( -> (.+))?$", options: [])
        
        var nodesByName = Dictionary<String, Node>()
        for line in lines {
            let string = String(line)
            let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))!
            let name = (string as NSString).substring(with: match.range(at: 1))
            let weight = (string as NSString).substring(with: match.range(at: 2))
            nodesByName[name] = Node(name, weight: Int(weight, radix: 10)!)
        }
        
        for line in lines {
            let string = String(line)
            let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))!
            let kidRange = match.range(at: 4)
            if kidRange.location == NSNotFound { continue }
            
            let name = (string as NSString).substring(with: match.range(at: 1))
            
            let kids = (string as NSString).substring(with: kidRange)
            let kidNames = kids.components(separatedBy: ", ")
            
            let node = nodesByName[name]!
            for kidName in kidNames {
                let kid = nodesByName[kidName]!
                node.add(child: kid)
            }
        }
        
        for value in nodesByName.values {
            if value.parent == nil { return value }
        }
        return nil
    }

    func run() {
        let root = makeTree()!

        print(root.name)
        root.computeWeights()
        let imbalanced = root.imbalancedChild()!
        let siblingWeights = Set(imbalanced.parent!.children.map { $0.computedWeight })
        let delta = siblingWeights.max()! - siblingWeights.min()!
        print(imbalanced.weight - delta)
    }

}
