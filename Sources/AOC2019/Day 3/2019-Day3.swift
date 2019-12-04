//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day3: Day {
    
    struct Segment {
        let start: XY
        let end: XY
        
        var xRange: ClosedRange<Int> { return min(start.x, end.x) ... max(start.x, end.x) }
        var yRange: ClosedRange<Int> { return min(start.y, end.y) ... max(start.y, end.y) }
        
        func intersection(with other: Segment) -> XY? {
            #warning("TODO: this")
            return nil
        }
    }
    
    override func run() -> (String, String) {
        let words = input.lines.csvWords
        
        var current = XY.zero
        let line1 = words[0].map { word -> Segment in
            let h = Heading(character: word.characters[0])!
            let l = Int(word.raw.dropFirst())!
            let n = current.move(h, length: l)
            let s = Segment(start: current, end: n)
            current = n
            return s
        }
        
        current = .zero
        let line2 = words[1].map { word -> Segment in
            let h = Heading(character: word.characters[0])!
            let l = Int(word.raw.dropFirst())!
            let n = current.move(h, length: l)
            let s = Segment(start: current, end: n)
            current = n
            return s
        }
        
        var intersections = Set(line1.flatMap { seg -> Array<XY> in
            return line2.compactMap { $0.intersection(with: seg) }
        })
        intersections.remove(.zero)
        
        let p1 = intersections.map { $0.manhattanDistance(to: .zero) }.min()!
        return ("\(p1)", "")
    }
    
    enum Marker {
        case line1
        case line2
        case both
    }
    
    struct LinePart {
        let direction: Heading
        let length: Int
    }
    
    func run_orig() -> (String, String) {
        let lines: Array<Array<LinePart>> = input.lines.csvWords.map { words in
            return words.compactMap { word -> LinePart? in
                guard let h = Heading(character: word.characters[0]) else { return nil }
                return LinePart(direction: h, length: Int(word.raw.dropFirst())!)
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
