//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/17/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2018 {

    public class Day18: Day {
        
        public init() { super.init(inputFile: #file) }
        
        typealias Grid = Dictionary<Position, AcreContents>
        
        enum AcreContents: Character {
            case open = "."
            case trees = "|"
            case lumberyard = "#"
        }
        
        lazy var acreage: Grid = {
            var final = Grid()
            for (y, line) in input.lines.enumerated() {
                for (x, c) in line.characters.enumerated() {
                    final[Position(x: x, y: y)] = AcreContents(rawValue: c)!
                }
            }
            return final
        }()
        
        private func tick(_ acreage: Grid) -> Grid {
            var new = Grid()
            
            for (p, c) in acreage {
                let surrounding = p.surroundingPositions(includingDiagonals: true)
                let surroundingContents = surrounding.compactMap { acreage[$0] }
                let count = CountedSet(counting: surroundingContents)
                
                let newContents: AcreContents
                switch c {
                    case .open:
                        if count.count(for: .trees) >= 3 {
                            newContents = .trees
                        } else {
                            newContents = .open
                        }
                    case .trees:
                        if count.count(for: .lumberyard) >= 3 {
                            newContents = .lumberyard
                        } else {
                            newContents = .trees
                        }
                    case .lumberyard:
                        if count.count(for: .lumberyard) >= 1 && count.count(for: .trees) >= 1 {
                            newContents = .lumberyard
                        } else {
                            newContents = .open
                        }
                }
                new[p] = newContents
            }
            
            return new
        }
        
        override public func part1() -> String {
            var current = acreage
            for _ in 0 ..< 10 {
                current = tick(current)
            }
            let count = CountedSet(counting: current.values)
            
            let trees = count.count(for: .trees)
            let lumber = count.count(for: .lumberyard)
            return "\(trees * lumber)"
        }
        
        override public func part2() -> String {
            var current = acreage
            var seen = Dictionary<Grid, Int>()
            seen[current] = 0
            
            for i in 1 ... 1_000_000_000 {
                current = tick(current)
                
                if let e = seen[current] {
                    // cycle
                    let numberOfRemainingIterations = 1_000_000_000 - i
                    
                    let cycleLength = i - e
                    let numberOfLeftoverIterations = numberOfRemainingIterations % cycleLength
                    
                    let target = e + numberOfLeftoverIterations
                    let targetGrid = seen.keys.first(where: { seen[$0] == target })!
                    let counts = CountedSet(counting: targetGrid.values)
                    
                    let trees = counts.count(for: .trees)
                    let lumber = counts.count(for: .lumberyard)
                    return "\(trees * lumber)"
                    
                } else {
                    seen[current] = i
                }
            }
            fatalError("Unreachable")
        }
        
    }

}
