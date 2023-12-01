//
//  Day12.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

class Day12: Day {
    
    struct CaveID: Hashable {
        let id: String
        var isSmall: Bool { id != "start" && id != "end" && id.first!.isLowercase }
        var isLarge: Bool { id != "start" && id != "end" && id.first!.isUppercase }
    }
    
    lazy var caveSystem: Graph<CaveID, CaveID> = {
        var g = Graph<CaveID, CaveID>()
        for line in input().lines.raw {
            let pieces = line.split(separator: .hyphen)
            let c1 = CaveID(id: String(pieces[0]))
            let c2 = CaveID(id: String(pieces[1]))
            
            _ = g.value(with: c1, default: c1)
            _ = g.value(with: c2, default: c2)
            
            g.connect(c1, to: c2)
        }
        return g
    }()
    
    var startCave: CaveID { CaveID(id: "start") }
    var endCave: CaveID { CaveID(id: "end") }

    func part1() async throws -> Int {
        let paths = self.computePaths(from: startCave, to: endCave)
        return paths.count
    }

    func part2() async throws -> Int {
        let paths = self.computePaths(from: startCave, to: endCave, smallCaveCount: 2)
        
        let uniqued = Set(paths)
        return uniqued.count
    }
    
    typealias CavePath = Array<CaveID>
    func computePaths(from start: CaveID, to end: CaveID, smallCaveCount: Int = 1) -> Array<CavePath> {
        var caves = Set(caveSystem.values)
        caves.remove(start)
        
        var counts = CountedSet<CaveID>(caves)
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
    
    private func _countPaths(from start: CaveID, to end: CaveID, visitableCaves: CountedSet<CaveID>) -> Array<CavePath> {
        var possibilities = caveSystem.connections(from: start)
        // only caves that can be visited are possible
        possibilities = possibilities.filter { visitableCaves.count(for: $0) > 0 }
        
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
