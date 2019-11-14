//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/9/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day10: Day {
    
    @objc init() { super.init(inputFile: #file) }
    
    struct Letter {
        let character: Character
        let relativePositions: Array<(Int, Int)>
        func positions(at offset: Int) -> Set<Position> {
            return Set(relativePositions.map { (x, y) in
                return Position(x: x + offset, y: y)
            })
        }
    }
    
    lazy var data: Array<(Position, Position)> = {
        // position=<-41981,  21153> velocity=< 4, -2>
        let r = Regex(pattern: "position=<\\s*(-?\\d+),\\s*(-?\\d+)> velocity=<\\s*(-?\\d+),\\s*(-?\\d+)>")
        return input.lines.raw.map { l -> (Position, Position) in
            let m = r.match(l)!
            return (Position(x: m.int(1)!, y: m.int(2)!), Position(x: m.int(3)!, y: m.int(4)!))
        }
    }()
    
    let letters: Array<Letter> = [
        Letter(character: "A", relativePositions: [
            (2, 0), (3, 0),
            (1, 1), (4, 1),
            (0, 2), (5, 2), (0, 3), (5, 3), (0, 4), (5, 4),
            (0, 5), (1, 5), (2, 5), (3, 5), (4, 5), (5, 5),
            (0, 6), (5, 6), (0, 7), (5, 7), (0, 8), (5, 8), (0, 9), (5, 9)
        ]),
        Letter(character: "B", relativePositions: [
            (0, 0), (1, 0), (2, 0), (3, 0), (4, 0),
            (0, 1), (5, 1), (0, 2), (5, 2), (0, 3), (5, 3),
            (0, 4), (1, 4), (2, 4), (3, 4), (4, 4),
            (0, 5), (5, 5), (0, 6), (5, 6), (0, 7), (5, 7), (0, 8), (5, 8),
            (0, 9), (1, 9), (2, 9), (3, 9), (4, 9)
        ]),
        Letter(character: "C", relativePositions: [
            (1, 0), (2, 0), (3, 0), (4, 0),
            (0, 1), (5, 1),
            (0, 2), (0, 3), (0, 4), (0, 5), (0, 6), (0, 7),
            (0, 8), (5, 8),
            (1, 9), (2, 9), (3, 9), (4, 9)
        ]),
        // don't have "D"
        Letter(character: "E", relativePositions: [
            (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0),
            (0, 1), (0, 2), (0, 3),
            (0, 4), (1, 4), (2, 4), (3, 4), (4, 4), (5, 4),
            (0, 5), (0, 6), (0, 7), (0, 8),
            (0, 9), (1, 9), (2, 9), (3, 9), (4, 9), (5, 9)
        ]),
        Letter(character: "F", relativePositions: [
            (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0),
            (0, 1), (0, 2), (0, 3),
            (0, 4), (1, 4), (2, 4), (3, 4), (4, 4),
            (0, 5), (0, 6), (0, 7), (0, 8), (0, 9)
        ]),
        Letter(character: "G", relativePositions: [
            (1, 0), (2, 0), (3, 0), (4, 0),
            (0, 1), (5, 1),
            (0, 2), (0, 3), (0, 4),
            (0, 5), (3, 5), (4, 5), (5, 5),
            (0, 6), (5, 6), (0, 7), (5, 7),
            (0, 8), (4, 8), (5, 8),
            (1, 9), (2, 9), (3, 9), (5, 9)
        ]),
        Letter(character: "H", relativePositions: [
            (0, 0), (5, 0), (0, 1), (5, 1), (0, 2), (5, 2), (0, 3), (5, 3),
            (0, 4), (1, 4), (2, 4), (3, 4), (4, 4), (5, 4),
            (0, 5), (5, 5), (0, 6), (5, 6), (0, 7), (5, 7), (0, 8), (5, 8), (0, 9), (5, 9)
        ]),
        // missing "I"
        Letter(character: "J", relativePositions: [
            (3, 0), (4, 0), (5, 0),
            (4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 6),
            (0, 7), (4, 7), (0, 8), (4, 8),
            (1, 9), (2, 9), (3, 9)
        ]),
        Letter(character: "K", relativePositions: [
            (0, 0), (0, 1), (0, 2), (0, 3), (0, 4), (0, 5), (0, 6), (0, 7), (0, 8), (0,9),
            (5, 0), (4, 1), (3, 2), (2, 3), (1, 4),
            (1, 5), (2, 6), (3, 7), (4, 8), (5, 9)
        ]),
        Letter(character: "L", relativePositions: [
            (0, 0), (0, 1), (0, 2), (0, 3), (0, 4), (0, 5), (0, 6), (0, 7), (0, 8), (0, 9),
            (0, 9), (1, 9), (2, 9), (3, 9), (4, 9), (5, 9)
        ]),
        // missing "M"
        Letter(character: "N", relativePositions: [
            (0, 0), (5, 0),
            (0, 1), (1, 1), (5, 1),
            (0, 2), (1, 2), (5, 2),
            (0, 3), (2, 3), (5, 3),
            (0, 4), (2, 4), (5, 4),
            (0, 5), (3, 5), (5, 5),
            (0, 6), (3, 6), (5, 6),
            (0, 7), (4, 7), (5, 7),
            (0, 8), (4, 8), (5, 8),
            (0, 9), (5, 9)
        ]),
        // missing "O"
        Letter(character: "P", relativePositions: [
            (0, 0), (0, 1), (0, 2), (0, 3), (0, 4), (0, 5), (0, 6), (0, 7), (0, 8), (0, 9),
            (1, 0), (2, 0), (3, 0), (4, 0), (5, 1), (5, 2), (5, 3),
            (1, 4), (2, 4), (3, 4), (4, 4)
        ]),
        // missing "Q"
        Letter(character: "R", relativePositions: [
            (0, 0), (1, 0), (2, 0), (3, 0), (4, 0),
            (0, 1), (5, 1), (0, 2), (5, 2), (0, 3), (5, 3),
            (0, 4), (1, 4), (2, 4), (3, 4), (4, 4),
            (0, 5), (3, 5), (0, 6), (4, 6),
            (0, 7), (4, 7), (0, 8), (5, 8), (0, 9), (5, 9)
        ]),
        // missing "S", "T", "U", "V", "W"
        Letter(character: "X", relativePositions: [
            (0, 0), (0, 1), (1, 2), (1, 3), (2, 4),
            (5, 0), (5, 1), (4, 2), (4, 3), (3, 4),
            (2, 5), (1, 6), (1, 7), (0, 8), (0, 9),
            (3, 5), (4, 6), (4, 7), (5, 8), (5, 9)
        ]),
        // missing "Y"
        Letter(character: "Z", relativePositions: [
            (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0),
            (5, 1), (5, 2), (4, 3), (3, 4),
            (2, 5), (1, 6), (0, 7), (0, 8),
            (0, 9), (1, 9), (2, 9), (3, 9), (4, 9), (5, 9)
        ])
    ]
    
    func increment(_ data: Array<(Position, Position)>) -> Array<(Position, Position)> {
        return data.map { (p, v) -> (Position, Position) in
            return (Position(x: p.x + v.x, y: p.y + v.y), v)
        }
    }
    
    private func print(positions: Set<Position>) {
        let (min, max) = Position.extremes(of: positions)
        var row = ""
        var lastY = min.y
        for gridPoint in Position.all(in: min.x...max.x, min.y...max.y) {
            if gridPoint.y != lastY {
                Swift.print(row)
                row = ""
                lastY = gridPoint.y
            }
            if positions.contains(gridPoint) {
                row.append("\u{2588}")
            } else {
                row.append(" ")
            }
        }
        Swift.print(row)
    }
    
    override func run() -> (String, String) {
        var d = data
        var (minY, maxY) = d.lazy.map({ $0.0.y }).extremes()
        var iterationCount = 0
        while maxY - minY > 10 {
            d = increment(d)
            (minY, maxY) = d.lazy.map({ $0.0.y }).extremes()
            iterationCount += 1
        }
        
        var finalPositions = Set(d.map { $0.0 })
        let (positionOffset, positionSize) = Position.extremes(of: finalPositions)
        
        // shift everything to be anchored at (0,0)
        finalPositions = Set(finalPositions.map { Position(x: $0.x - positionOffset.x, y: $0.y - positionOffset.y) })
        let boundingWidth = positionSize.x - positionOffset.x
        
        var word = ""
        
        var foundLetter = true
        while foundLetter == true {
            foundLetter = false // reset for this loop
            
            let horizontalOffsetOfNextLetter = word.count * 8
            guard horizontalOffsetOfNextLetter < boundingWidth else { continue }
            for letter in letters {
                let letterPositions = letter.positions(at: horizontalOffsetOfNextLetter)
                if letterPositions.isSubset(of: finalPositions) {
                    word.append(letter.character)
                    foundLetter = true
                    break
                }
            }
        }
        
        print(positions: finalPositions)
        
        return (word, "\(iterationCount)")
    }

}
