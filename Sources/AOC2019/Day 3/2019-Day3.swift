//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day3: Day {
    
    enum Marker {
        case line1
        case line2
        case both
    }
    
    struct Segment {
        let direction: Heading
        let length: Int
    }
    
    override func run() -> (String, String) {
        
        let comma = CharacterSet(charactersIn: ",")
        
        let lines: Array<Array<Segment>> = input.lines.words(separatedBy: comma).map { words in
            return words.map { word -> Segment in
                let heading: Heading
                switch word.characters[0] {
                case "U": heading = .north
                case "D": heading = .south
                case "L": heading = .west
                case "R": heading = .east
                default: fatalError()
                }
                let length = Int(word.raw.dropFirst())!
                return Segment(direction: heading, length: length)
            }
        }
        
        // build up an "infinite" grid of marker values
        var grid = Dictionary<XY, Marker>()
        
        // basically, walk through each line and mark that position in the grid as having been visited
        var position = XY.zero
        grid[position] = .both
        for segment in lines[0] {
            for _ in 0 ..< segment.length {
                position = position.move(segment.direction)
                grid[position] = .line1
            }
        }
        
        position = XY.zero
        for segment in lines[1] {
            for _ in 0 ..< segment.length {
                position = position.move(segment.direction)
                if grid[position] == .line1 {
                    // line 1 has been here, so both lines have been here
                    grid[position] = .both
                } else if grid[position] == nil {
                    // only line 2 has been here
                    grid[position] = .line2
                }
            }
        }
        
        // find all the intersections
        var intersections = grid.filter { $0.value == .both }
        // remove the "central port"
        intersections[.zero] = nil
        // get the smallest manhattan distance to the central port
        let closestIntersection = intersections.keys.map { $0.manhattanDistance(to: .zero) }.min()!
        
        
        // for part 2, we'll run through each line again
        // this time we're going to count how many steps it took to get to a position
        // if that position is an intersection, we'll record that stepcount into a dictionary
        var line1Steps = Dictionary<XY, Int>()
        var line2Steps = Dictionary<XY, Int>()
        
        var stepCount = 0
        position = .zero
        for segment in lines[0] {
            for _ in 0 ..< segment.length {
                position = position.move(segment.direction)
                stepCount += 1
                if intersections[position] != nil {
                    line1Steps[position] = stepCount
                }
            }
        }
        
        
        stepCount = 0
        position = .zero
        for segment in lines[1] {
            for _ in 0 ..< segment.length {
                position = position.move(segment.direction)
                stepCount += 1
                if intersections[position] != nil {
                    line2Steps[position] = stepCount
                }
            }
        }
        
        // turn each intersection into the sum of the step counts to get there
        let steps = intersections.map { elem in
            return line1Steps[elem.key]! + line2Steps[elem.key]!
        }
        
        // the part 2 answer is the shortest distance
        let shortest = steps.min()!
        
        return ("\(closestIntersection)", "\(shortest)")
    }
    
}
