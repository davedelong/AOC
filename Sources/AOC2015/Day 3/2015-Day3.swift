//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

extension Year2015 {

    public class Day3: Day {
        
        public init() { super.init(inputFile: #file) }
        
        lazy var headings: Array<Heading> = {
            return input.characters.compactMap { char -> Heading? in
                switch char {
                    case "^": return .north
                    case "<": return .west
                    case ">": return .east
                    case "v": return .south
                    default: return nil
                }
            }
        }()
        
        override public func part1() -> String {
            var presentCount = CountedSet<Position>()
            
            var current = Position(x: 0, y: 0)
            for heading in headings {
                presentCount[current, default: 0] += 1
                current = current.move(heading)
            }
            return "\(presentCount.count)"
        }
        
        override public func part2() -> String {
            var presentCount = [
                Position(x: 0, y: 0): 2
            ]
            
            var santaPositions = [
                Position(x: 0, y: 0),
                Position(x: 0, y: 0)
            ]
            
            var currentSanta = 0
            for heading in headings {
                let position = santaPositions[currentSanta].move(heading)
                presentCount[position, default: 0] += 1
                santaPositions[currentSanta] = position
                currentSanta = (currentSanta + 1) % santaPositions.count
            }
            
            return "\(presentCount.count)"
        }
        
    }

}
