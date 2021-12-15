//
//  Day15.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import GameplayKit

class Day15: Day {
    
    /*
     this is probably a relatively inefficient way to solve this
     
     but you know what?
     
     I'm kind of sick of writing path finding code. So here we are.
     */

    override func part1() -> String {
        let graph: GKGridGraph<CostNode> = {
            let width = input.lines[0].characters.count
            let height = input.lines.count
            
            let graph = GKGridGraph<CostNode>(fromGridStartingAt: vector_int2(x: 0, y: 0),
                                    width: Int32(width),
                                    height: Int32(height),
                                    diagonalsAllowed: false,
                                              nodeClass: CostNode.self)
            
            (0 ..< input.lines.count).forEach { y in
                let row = input.lines[y].characters
                (0 ..< row.count).forEach { x in
                    let node = graph.node(atGridPosition: vector_int2(x: Int32(x), y: Int32(y)))!
                    node.cost = Int(row[x])!
                }
            }
            return graph
        }()
        
        let topLeft = graph.node(atGridPosition: vector_int2(x: 0, y: 0))!
        let bottomRight = graph.node(atGridPosition: vector_int2(x: Int32(graph.gridWidth-1),
                                                                 y: Int32(graph.gridHeight-1)))!
        let path = graph.findPath(from: topLeft, to: bottomRight) as! Array<CostNode>
        
        let cost = path.dropFirst().sum(of: \.cost)
        
        return "\(cost)"
    }

    override func part2() -> String {
        let graph: GKGridGraph<CostNode> = {
            let width = input.lines[0].characters.count
            let height = input.lines.count
            
            let graph = GKGridGraph<CostNode>(fromGridStartingAt: vector_int2(x: 0, y: 0),
                                    width: Int32(width * 5),
                                    height: Int32(height * 5),
                                    diagonalsAllowed: false,
                                              nodeClass: CostNode.self)
            
            for y in (0 ..< input.lines.count) {
                let row = input.lines[y]
                for x in (0 ..< row.characters.count) {
                    let col = row.characters[x]
                    let baseValue = Int(col)!
                    
                    for xOffset in 0 ..< 5 {
                        for yOffset in 0 ..< 5 {
                            let position = vector_int2(Int32(x + (xOffset * row.characters.count)),
                                                       Int32(y + (yOffset * input.lines.count)))
                            let node = graph.node(atGridPosition: position)!
                            
                            let cost = (baseValue + xOffset + yOffset) % 9
                            node.cost = cost == 0 ? 9 : cost
                        }
                    }
                }
            }
            return graph
        }()
        
        let topLeft = graph.node(atGridPosition: vector_int2(x: 0, y: 0))!
        let bottomRight = graph.node(atGridPosition: vector_int2(x: Int32(graph.gridWidth-1),
                                                                 y: Int32(graph.gridHeight-1)))!
        let path = graph.findPath(from: topLeft, to: bottomRight) as! Array<CostNode>
        print(path.map(\.cost))
        
        let cost = path.dropFirst().sum(of: \.cost)
        
        return "\(cost)"
    }

}

class CostNode: GKGridGraphNode {
    var cost: Int = 0
    init(x: Int, y: Int, cost: Int) {
        self.cost = cost
        super.init(gridPosition: vector_int2(x: Int32(x), y: Int32(y)))
    }
    
    override init(gridPosition: vector_int2) {
        super.init(gridPosition: gridPosition)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func cost(to node: GKGraphNode) -> Float {
        return Float(cost)
    }
}
