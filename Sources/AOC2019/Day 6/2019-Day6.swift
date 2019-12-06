//
//  Day6.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day6: Day {
    
    override func run() -> (String, String) {
        let lines = input.lines.words(separatedBy: ")")
        
        var nodes = Dictionary<String, Node<String>>()
        for pieces in lines {
            let parentName = pieces[0].raw
            let childName = pieces[1].raw
            
            let parentNode = nodes[parentName] ?? Node(value: parentName)
            let childNode = nodes[childName] ?? Node(value: childName)
            
            parentNode.addChild(childNode)
            nodes[parentName] = parentNode
            nodes[childName] = childNode
        }
        
        let countsToRoot = nodes.values.map { $0.numberOfParents }
        let sum = countsToRoot.sum()
        let p1 = "\(sum)"
        
        let myNode = nodes["YOU"]!
        let santa = nodes["SAN"]!
        let commonRoot = myNode.firstParentInCommon(with: santa)!
        
        let myCount = myNode.numberOfParents(to: commonRoot)
        let santaCount = santa.numberOfParents(to: commonRoot)
        
        
        
        let p2 = "\(myCount + santaCount)"
        
        return (p1, p2)
    }
    
}
