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
        private var costMap = Dictionary<GKGraphNode, Int>()
        
        var subBags: Array<Bag> { return connectedNodes.compactMap { $0 as? Bag } }
        
        func addBag(_ other: Bag, requiredAmount: Int) {
            super.addConnections(to: [other], bidirectional: false)
            costMap[other] = requiredAmount
        }
        
        override func cost(to node: GKGraphNode) -> Float {
            if let c = costMap[node] { return Float(c) }
            return super.cost(to: node)
        }
    }
    
    override func run() -> (String, String) {
        
        var nodes = Dictionary<String, Bag>()
        
        for line in input.rawLines {
            let name = nameRegex.match(line)![1]!
            let nameNode: Bag
            if let e = nodes[name] {
                nameNode = e
            } else {
                nameNode = Bag()
                nodes[name] = nameNode
            }
            
            for match in bagRegex.matches(in: line) {
                let contained: Bag
                if let e = nodes[match[2]!] {
                    contained = e
                } else {
                    contained = Bag()
                    nodes[match[2]!] = contained
                }
                nameNode.addBag(contained, requiredAmount: match[int: 1]!)
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
        
        var p2 = 0
        var toProcess = [target]
        while toProcess.isNotEmpty {
            let next = toProcess.removeFirst()
            let contained = next.subBags
            for other in contained {
                let cost = Int(next.cost(to: other))
                for _ in 0 ..< cost {
                    toProcess.append(other)
                }
                p2 += cost
            }
        }
        
        return ("\(p1)", "\(p2)")
    }

}
