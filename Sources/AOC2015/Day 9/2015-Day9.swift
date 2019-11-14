//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/8/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day9: Day {
    
    @objc init() {
//            super.init(inputSource: .raw(
//            """
//London to Dublin = 464
//London to Belfast = 518
//Dublin to Belfast = 141
//"""
//            ))
        
        super.init(inputSource: .file(#file))
    }
    
    typealias Edge = Pair<String>
    typealias Path = (Array<String>, Int)
    
    lazy var graph: Dictionary<Edge, Int> = {
        let r = Regex(pattern: "(.+?) to (.+?) = (\\d+)")
        
        var g = Dictionary<Edge, Int>()
        for line in input.lines.raw {
            let m = r.match(line)!
            g[Pair(m[1]!, m[2]!)] = m.int(3)!
        }
        return g
    }()
    
    lazy var paths: Array<Path> = {
        let allCities = Set(graph.keys.flatMap { [$0.first, $0.second] })
        
        let paths = allCities.flatMap {
            return buildPaths(parent: ([$0], 0), cities: allCities, graph: graph)
        }
        return paths
    }()
    
    private func buildPaths(parent: Path, cities: Set<String>, graph: Dictionary<Edge, Int>) -> Array<Path> {
        let lastCity = parent.0.last!
        let citiesToVisit = cities.subtracting(parent.0)
        guard citiesToVisit.isEmpty == false else { return [parent] }
        
        let paths = citiesToVisit.flatMap { c -> Array<Path> in
            let edge1 = Pair(lastCity, c)
            let edge2 = Pair(c, lastCity)
            let distance = graph.first { $0.key == edge1 || $0.key == edge2 }!.value
            
            let p = (parent.0 + [c], parent.1 + distance)
            return buildPaths(parent: p, cities: cities, graph: graph)
        }
        
        return paths
    }
    
    override func part1() -> String {
        let shortestFirst = paths.sorted { $0.1 < $1.1 }
        let shortest = shortestFirst[0]
        
        return "\(shortest.1)"
    }
    
    override func part2() -> String {
        let longestFirst = paths.sorted { $0.1 > $1.1 }
        let longest = longestFirst[0]
        
        return "\(longest.1)"
    }

}
