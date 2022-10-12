//
//  Day15.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import GameplayKit
import AOCCore

class Day15: Day {
    
    /*
     this is probably a relatively inefficient way to solve this
     
     but you know what?
     
     I'm kind of sick of writing path finding code. So here we are.
     */

    func part1() async throws -> Int {
        var graph = GridGraph(input().lines.digits)
        graph.defaultTravelCost = 0
        for p in Array(graph.rect) {
            let value = graph[p]!
            graph[entranceCost: p] = Float(value)
        }
        
        let cost = Int(graph.cost(from: .zero, to: Position(x: graph.width - 1, y: graph.height - 1))!)
        
        return cost
    }

    func part2() async throws -> Int {
        let digits = input().lines.digits
        let width = digits[0].count * 5
        let height = digits.count * 5
        var g = GridGraph<Int>(width: width, height: height)
        g.defaultTravelCost = 0
        
        for y in 0 ..< digits.count {
            let row = digits[y]
            for x in 0 ..< row.count {
                let baseValue = row[x]
                for xOffset in 0 ..< 5 {
                    for yOffset in 0 ..< 5 {
                        let cost = (baseValue + xOffset + yOffset) % 9
                        let actualCost = cost == 0 ? 9 : cost
                        let p = Position(x: x + (xOffset * row.count), y: y + (yOffset * digits.count))
                        g[p] = actualCost
                        g[entranceCost: p] = Float(actualCost)
                    }
                }
            }
        }
        
        let cost = Int(g.cost(from: .zero, to: Position(x: g.width - 1, y: g.height - 1))!)
        
        return cost
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
