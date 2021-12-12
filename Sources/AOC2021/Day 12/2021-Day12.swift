//
//  Day12.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

class Day12: Day {
    
    struct Cave: Hashable, GraphNode {
        let id: String
        var isSmall: Bool { id != "start" && id != "end" && id.first!.isLowercase }
        var isLarge: Bool { id != "start" && id != "end" && id.first!.isUppercase }
    }
    
    lazy var caveSystem: Graph<Cave> = {
        let g = Graph<Cave>()
        for line in input.rawLines {
            let pieces = line.split(on: "-")
            let c1 = String(pieces[0])
            let c2 = String(pieces[1])
            
            let cave1 = g.node(with: c1, default: Cave(id: c1))
            let cave2 = g.node(with: c2, default: Cave(id: c2))
            
            g.connect(node: cave1, to: cave2)
        }
        return g
    }()
    
    var startCave: Cave { caveSystem.node(with: "start")! }
    var endCave: Cave { caveSystem.node(with: "end")! }

    override func part1() -> String {
        let paths = self.computePaths(from: startCave, to: endCave)
        return "\(paths.count)"
    }

    override func part2() -> String {
        let paths = self.computePaths(from: startCave, to: endCave, smallCaveCount: 2)
        
        let uniqued = Set(paths)
        return "\(uniqued.count)"
    }
    
    typealias CavePath = Array<Cave>
    func computePaths(from start: Cave, to end: Cave, smallCaveCount: Int = 1) -> Array<CavePath> {
        var caves = Set(caveSystem.nodes)
        caves.remove(start)
        
        var counts = CountedSet<Cave>(counting: caves)
        for cave in caves {
            if cave.isLarge { counts[cave] = Int.max }
        }
        
        if smallCaveCount > 1 {
            var total = Array<CavePath>()
            for cave in caves {
                if cave.isSmall {
                    counts[cave] = smallCaveCount
                    total += _countPaths(from: start, to: end, visitableCaves: counts)
                    counts[cave] = 1
                }
            }
            return total
        } else {
            return _countPaths(from: start, to: end, visitableCaves: counts)
        }
    }
    
    private func _countPaths(from start: Cave, to end: Cave, visitableCaves: CountedSet<Cave>) -> Array<CavePath> {
        var possibilities = caveSystem.connections(from: start)
        // only caves that can be visited are possible
        possibilities.removeAll(where: { visitableCaves.count(for: $0) == 0 })
        
        var remainingVisitable = visitableCaves
        remainingVisitable.remove(item: start) // mark that we've visited this cave
        
        var finalPathCount = Array<CavePath>()
        for possibility in possibilities {
            if possibility == end {
                finalPathCount.append([start, end])
            } else {
                let possible = _countPaths(from: possibility, to: end, visitableCaves: remainingVisitable)
                possible.forEach {
                    finalPathCount.append([start] + $0)
                }
            }
        }
        
        return finalPathCount
    }

}
