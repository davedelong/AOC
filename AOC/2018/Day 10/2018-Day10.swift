//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/9/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2018 {

    public class Day10: Day {
        
        public init() { super.init(inputSource: .file(#file)) }
        
        struct Letter {
            let character: Character
            let width: Int
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
                return (Position(x: Int(m[1]!)!, y: Int(m[2]!)!), Position(x: Int(m[3]!)!, y: Int(m[4]!)!))
            }
        }()
        
        let letters: Array<Letter> = [
            Letter(character: "F", width: 6, relativePositions: [
                (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0),
                (0, 1), (0, 2), (0, 3),
                (0, 4), (1, 4), (2, 4), (3, 4), (4, 4),
                (0, 5), (0, 6), (0, 7), (0, 8), (0, 9)
            ]),
            Letter(character: "K", width: 6, relativePositions: [
                (0, 0), (0, 1), (0, 2), (0, 3), (0, 4), (0, 5), (0, 6), (0, 7), (0, 8), (0,9),
                (5, 0), (4, 1), (3, 2), (2, 3), (1, 4),
                (1, 5), (2, 6), (3, 7), (4, 8), (5, 9)
            ]),
            Letter(character: "L", width: 6, relativePositions: [
                (0, 0), (0, 1), (0, 2), (0, 3), (0, 4), (0, 5), (0, 6), (0, 7), (0, 8), (0, 9),
                (0, 9), (1, 9), (2, 9), (3, 9), (4, 9), (5, 9)
            ]),
            Letter(character: "P", width: 6, relativePositions: [
                (0, 0), (0, 1), (0, 2), (0, 3), (0, 4), (0, 5), (0, 6), (0, 7), (0, 8), (0, 9),
                (1, 0), (2, 0), (3, 0), (4, 0), (5, 1), (5, 2), (5, 3),
                (1, 4), (2, 4), (3, 4), (4, 4)
            ]),
            Letter(character: "X", width: 6, relativePositions: [
                (0, 0), (0, 1), (1, 2), (1, 3), (2, 4),
                (5, 0), (5, 1), (4, 2), (4, 3), (3, 4),
                (2, 5), (1, 6), (1, 7), (0, 8), (0, 9),
                (3, 5), (4, 6), (4, 7), (5, 8), (5, 9)
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
                    row.append("#")
                } else {
                    row.append(" ")
                }
            }
            Swift.print(row)
        }
        
        override public func run() -> (String, String) {
            var d = data
            var (minY, maxY) = d.lazy.map({ $0.0.y }).extremes()
            var iterationCount = 0
            while maxY - minY > 10 {
                d = increment(d)
                (minY, maxY) = d.lazy.map({ $0.0.y }).extremes()
                iterationCount += 1
            }
            
            var finalPositions = Set(d.map { $0.0 })
            let (positionOffset, _) = Position.extremes(of: finalPositions)
            finalPositions = Set(finalPositions.map { Position(x: $0.x - positionOffset.x, y: $0.y - positionOffset.y) })
//            print(positions: finalPositions)
//
//            for letter in letters {
//                Swift.print("\(letter.character)-----------------")
//                print(positions: letter.positions(at: 0))
//            }
            
            let (_, maxX) = finalPositions.map { $0.x }.extremes()
            
            var word = ""
            var offset = 0
            while offset < maxX {
                for letter in letters {
                    let letterPositions = letter.positions(at: offset)
                    if letterPositions.isSubset(of: finalPositions) {
                        word.append(letter.character)
                        offset += letter.width + 1
                        break
                    }
                }
                offset += 1
            }
            
            return (word, "\(iterationCount)")
        }
        
    }

}
