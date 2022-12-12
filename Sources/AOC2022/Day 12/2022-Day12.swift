//
//  Day12.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day12: Day {
    typealias Part1 = Int
    typealias Part2 = Int

    func run() async throws -> (Part1, Part2) {
        var S = Point2.zero
        var E = Point2.zero
        
        let matrix = Matrix<Character>(input().lines.enumerated().map { (row, line) -> [Character] in
            return line.characters.enumerated().map { (col, char) -> Character in
                if char == "S" { S = Point2(row: row, column: col); return "a" }
                if char == "E" { E = Point2(row: row, column: col); return "z" }
                return char
            }
        })
        
        var graph = GridGraph(matrix: matrix)
        for (p, character) in graph {
            let val = character.alphabeticIndex!
            
            for other in p.orthogonalNeighbors() {
                guard let char = graph[other] else { continue }
                let oVal = char.alphabeticIndex!
                
                if oVal - val > 1 {
                    // this position is too much of a height change
                    // you cannot travel from p -> other
                    // ... but you CAN travel from other -> p
                    graph.disconnect(p, from: other, bidirectional: false)
                }
            }
        }
        
        let p1 = graph.path(from: S, to: E).dropFirst().count
        
        let aPositions = graph.filter { $0.value == "a" }.map(\.position)
        let aCounts = aPositions.map { graph.path(from: $0, to: E).dropFirst().count }.filter { $0 > 0 }
        
        let p2 = aCounts.min()!
        
        
        return (p1, p2)
    }

}
