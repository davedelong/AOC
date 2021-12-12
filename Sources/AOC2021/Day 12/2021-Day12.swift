//
//  Day12.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import GameplayKit

class Day12: Day {
    
    lazy var caveSystem: GKGraph = {
        var caves = Dictionary<String, Cave>()
        
        let graph = GKGraph([])
        for line in input.rawLines {
            let pieces = line.split(on: "-")
            let c1 = String(pieces[0])
            let c2 = String(pieces[1])
            
            let cave1: Cave
            let cave2: Cave
            if let c = caves[c1] {
                cave1 = c
            } else {
                cave1 = Cave(name: c1)
                caves[c1] = cave1
            }
            if let c = caves[c2] {
                cave2 = c
            } else {
                cave2 = Cave(name: c2)
                caves[c2] = cave2
            }
            
            graph.add([cave1, cave2])
            cave1.addConnections(to: [cave2], bidirectional: true)
        }
        return graph
    }()
    
    var startCave: Cave {
        (caveSystem.nodes as! Array<Cave>).first(where: { $0.name == "start" })!
    }
    
    var endCave: Cave {
        (caveSystem.nodes as! Array<Cave>).first(where: { $0.name == "end" })!
    }

    override func run() -> (String, String) {
        return super.run()
    }

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
        var caves = Set(caveSystem.nodes as! Array<Cave>)
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
        var possibilities = start.connectedNodes as! Array<Cave>
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

class Cave: GKGraphNode {
    let name: String
    var isSmall: Bool { name != "start" && name != "end" && name.first!.isLowercase }
    var isLarge: Bool { name != "start" && name != "end" && name.first!.isUppercase }
    
    override var description: String { name }
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
