//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/13/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day13: Day {
    
    @objc init() {
//            super.init(inputSource: .raw(
//                """
///->-\\
//|   |  /----\\
//| /-+--+-\\  |
//| | |  | v  |
//\\-+-/  \\-+--/
//\\------/
//"""))
        super.init(inputSource: .file(#file))
    }
    
    override func run() -> (String, String) {
        
        let track = input.lines.characters
        
        var cartHeadings = Dictionary<Position, (Heading, Int)>()
        for (y, line) in track.enumerated() {
            for (x, character) in line.enumerated() {
                switch character {
                    case ">": cartHeadings[Position(x: x, y: y)] = (.east, 0)
                    case "<": cartHeadings[Position(x: x, y: y)] = (.west, 0)
                    case "^": cartHeadings[Position(x: x, y: y)] = (.north, 0)
                    case "v": cartHeadings[Position(x: x, y: y)] = (.south, 0)
                    default: break
                }
            }
        }
        
        var positionOfFirstCrash: Position? = nil
        while cartHeadings.count > 1 {
            let sortedPositions = cartHeadings.sorted(by: {
                if $0.key.y < $1.key.y { return true }
                if $0.key.y > $1.key.y { return false }
                if $0.key.x < $1.key.x { return true }
                return false
            })
            
            for (oldPosition, (heading, intersectionCount)) in sortedPositions {
                cartHeadings[oldPosition] = nil
                let newPosition = oldPosition.move(heading)
                
                if cartHeadings[newPosition] != nil {
                    // there's a cart here
                    if positionOfFirstCrash == nil { positionOfFirstCrash = newPosition }
                    cartHeadings[newPosition] = nil
                } else {
                    // a cart does not occupy this new position
                    // figure out if this cart needs to rotate to follow the track
                    
                    var newHeading = heading
                    var newIntersectionCount = intersectionCount
                    switch track[newPosition.y][newPosition.x] {
                        case "+":
                            switch intersectionCount % 3 {
                                case 0: newHeading = heading.turnLeft()
                                case 1: newHeading = heading
                                case 2: newHeading = heading.turnRight()
                                default: fatalError()
                            }
                            newIntersectionCount += 1
                        case "\\":
                            switch heading {
                                case .south: newHeading = heading.turnLeft()
                                case .north: newHeading = heading.turnLeft()
                                case .east: newHeading = heading.turnRight()
                                case .west: newHeading = heading.turnRight()
                            }
                        case "/":
                            switch heading {
                                case .south: newHeading = heading.turnRight()
                                case .north: newHeading = heading.turnRight()
                                case .east: newHeading = heading.turnLeft()
                                case .west: newHeading = heading.turnLeft()
                            }
                        default:
                            break
                    }
                    
                    cartHeadings[newPosition] = (newHeading, newIntersectionCount)
                }
            }
        }
        
        let p1 = positionOfFirstCrash!
        let p2 = cartHeadings.first!.key
        return ("\(p1.x),\(p1.y)", "\(p2.x),\(p2.y)")
    }
    
}
