//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/11/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

extension Year2017 {

class Day12: Day {

    func nodes(connectedTo node: GKGraphNode) -> Set<GKGraphNode> {
        var processed = Set<GKGraphNode>()
        var remaining = [node]
        
        while let next = remaining.popLast() {
            processed.insert(next)
            let connections = next.connectedNodes.filter { processed.contains($0) == false }
            remaining.append(contentsOf: connections)
        }
        return processed
    }
    
    let nodesByName: Dictionary<String, GKGraphNode>
    
    required init() {
        let connections = Day12.inputLines().map { line -> (String, [String]) in
            let pieces = line.components(separatedBy: " <-> ")
            return (pieces[0], pieces[1].components(separatedBy: ", "))
        }

        var nodes = Dictionary<String, GKGraphNode>()
        for c in connections { nodes[c.0] = GKGraphNode() }

        for c in connections {
            nodes[c.0]!.addConnections(to: c.1.map { nodes[$0]! }, bidirectional: true)
        }
        nodesByName = nodes
    }

    func part1() -> String {
        let zero = nodesByName["0"]!
        return "\(nodes(connectedTo: zero).count)"
    }

    func part2() -> String {
        var allNodes = Set(nodesByName.values)
        var subGraphCount = 1
        while allNodes.isEmpty == false {
            subGraphCount += 1
            
            let anyNode = allNodes.first!
            let connectionsToThisNode = nodes(connectedTo: anyNode)
            allNodes.subtract(connectionsToThisNode)
        }
        return "\(subGraphCount)"
    }

}

}
