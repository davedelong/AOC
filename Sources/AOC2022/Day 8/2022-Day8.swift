//
//  Day8.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day8: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    enum Tree: Hashable {
        case unvisited(Int)
        case visible(Int)
        case invisible(Int)
        
        var isVisible: Bool {
            if case .visible = self { return true }
            return false
        }
    }

    func run() async throws -> (Part1, Part2) {
        let trees = Matrix(input().lines.map(\.digits))
        
        func isVisibleFromEdge(_ position: Point2, along vector: Vector2) -> Bool {
            let treeHeight = trees[position]
            var current = position
            while trees.has(current) {
                
                let next = current.move(vector)
                if !trees.has(next) { return true }
                let nextHeight = trees[next]
                if nextHeight >= treeHeight { return false }
                
                current = next
            }
            return true
        }
        
        func isVisibleFromEdge(_ position: Point2) -> Bool {
            return Heading.cardinalHeadings.any(satisfy: { isVisibleFromEdge(position, along: $0) })
        }
        
        func visibleTrees(_ position: Point2, along vector: Vector2) -> Int {
            var count = 0
            var current = position.move(vector)
            
            while trees.has(current) {
                count += 1
                if trees[current] >= trees[position] { break }
                current = current.move(vector)
            }
            
            return count
        }
        
        var count = 0
        var maxScore = 0
        
        for pos in trees.positions {
            if isVisibleFromEdge(pos) {
                count += 1
            }
            let visible = Heading.cardinalHeadings.map { visibleTrees(pos, along: $0) }
//            print("VISIBLE @ ", pos, ":", visible, "(Score: \(visible.product))")
            let score = visible.product
            if score > maxScore {
//                print("NEW MAX", score, "AT", pos, ":", score)
                maxScore = max(maxScore, score)
            }
        }
        
        return (count, maxScore)
    }

}
