//
//  Day7.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

import GameplayKit

class Day7: Day {

    let nameRegex: Regex = #"^(.+?) bags?"#
    let bagRegex: Regex = #"(\d+) (.+?) bags?"#
    
    class Bag: GKGraphNode {
        private var countMap = Dictionary<Bag, Int>()
        
        var subBags: Array<Bag> { return connectedNodes.compactMap { $0 as? Bag } }
        
        var totalCount: Int {
            return countMap.reduce(into: 0) { $0 += (($1.key.totalCount + 1) * $1.value) }
        }
        
        func addBag(_ other: Bag, count: Int) {
            super.addConnections(to: [other], bidirectional: false)
            countMap[other] = count
        }
        
        override func cost(to node: GKGraphNode) -> Float {
            if let bag = node as? Bag, let count = countMap[bag] { return Float(count) }
            return super.cost(to: node)
        }

    }
    
    override func run() -> (String, String) {
        
        var nodes = Dictionary<String, Bag>()
        
        for line in input.rawLines {
            let name = nameRegex.match(line)![1]!
            let nameNode = nodes[name, inserting: Bag()]
            
            for match in bagRegex.matches(in: line) {
                let contained = nodes[match[2]!, inserting: Bag()]
                nameNode.addBag(contained, count: match[int: 1]!)
            }
        }
        
        let graph = GKGraph(Array(nodes.values))
        let target = nodes["shiny gold"]!
        
        var p1 = 0
        for other in nodes.values {
            if other == target { continue }
            let path = graph.findPath(from: other, to: target)
            p1 += (path.isEmpty ? 0 : 1)
        }
        
        let p2 = target.totalCount
        
        return ("\(p1)", "\(p2)")
    }

}
