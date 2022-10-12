//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day3: Day {
    
    enum Landscape: Character {
        case empty = "."
        case tree = "#"
    }
    
    lazy var landscapeElevations = input().lines.characters.map { $0.compactMap(Landscape.init(rawValue:)) }

    func part1() async throws -> Int {
        return traverse(using: Vector2(x: 3, y: 1))
    }

    func part2() async throws -> Int {
        let vectors = [
            Vector2(x: 1, y: 1),
            Vector2(x: 3, y: 1),
            Vector2(x: 5, y: 1),
            Vector2(x: 7, y: 1),
            Vector2(x: 1, y: 2),
        ]
        
        let counts = vectors.map {
            self.traverse(using: $0)
        }
        
        return counts.product
    }
    
    func traverse(using vector: Vector2) -> Int {
        var treeCount = 0
        var position = Point2.zero
        while position.y < landscapeElevations.count {
            let elevation = landscapeElevations[position.y]
            let feature = elevation[position.x % elevation.count]
            if feature == .tree {
                treeCount += 1
            }
            position += vector
        }
        return treeCount
    }

}
