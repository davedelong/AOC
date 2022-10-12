//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/18/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day19: Day {
    
    func part1() async throws -> String {
        
        var count = 0
        for x in 0 ..< 50 {
            for y in 0 ..< 50 {
                var localInput = [x, y]
                let i = Intcode(memory: input().integers)
                i.input = { localInput.removeFirst() }
                i.output = { count += $0 }
                i.runWithHandlers()
            }
        }
        
        return "\(count)"
    }
    
    func part2() async throws -> String {
        /**
          The beam looks like this:
         
         #.................................................
         ..#...............................................
         ....#.............................................
         ......#...........................................
         ........#.........................................
         .........##.......................................
         ...........##.....................................
         .............###..................................
         ...............###................................
         ................####..............................
         ..................####............................
         ....................####..........................
         ......................####........................
         .......................#####......................
         .........................######...................
         ...........................######.................
         .............................######...............
         ..............................#######.............
         ................................#######...........
         ..................................#######.........
         ....................................########......
         .....................................#########....
         .......................................#########..
         .........................................#########
         ...........................................#######
         ............................................######
         ..............................................####
         ................................................##
         ..................................................
         
         Observe a couple of things:
         1. This is not a 45° angle; the beam moves horizontally faster than it moves vertically
         2. There are some columns that don't have a beam (x = 1, x = 3, x = 5, x = 7)
         3. In order for a box to be "closest" to the origin, its bottom-left and top-right corners must
            necessarily lie ON THE EDGES OF THE BEAM
         
         Therefore:
         1. You only need to compute the upper and lower edges of the beam
         2. For the lower edge, the next X coordinate is *always* greater-than-or-equal to the previous one
         3. For the upper edge, the next Y coordinate (except for the missing columns) is *always* GTOE to the previous one
         **/
        
        // compute the lower edge of the beam
        // every horizontal line has a beam in it, so we don't need to account for any weirdness
        var currentX = 0
        var lowerBound = Array<XY>()
        for y in 0 ..< 5_000 {
            var foundEdge = false
            while foundEdge == false {
                var localInput = [currentX, y]
                let i = Intcode(memory: input().integers)
                i.input = { return localInput.removeFirst() }
                i.runWithHandlers()
                if i.io! == 1 {
                    foundEdge = true
                } else {
                    currentX += 1
                }
            }
            
            // found the edge; record it IN ORDER and move to the next one
            lowerBound.append(XY(x: currentX, y: y)) // 0,0; 2,1; 4,2; 6;3, ...
        }
        
        // compute the upper edge of the beam
        // since some columns don't have the beam, we need to watch for that
        var upperBound = Set<XY>()
        var currentY = 0
        var lastY = 0
        for x in 0 ..< 5_000 {
            var foundEdge = false
            // loop until we either found an edge or we've gone past a 45° angle
            while foundEdge == false && currentY <= x {
                var localInput = [x, currentY]
                let i = Intcode(memory: input().integers)
                i.input = { return localInput.removeFirst() }
                i.runWithHandlers()
                if i.io! == 1 {
                    foundEdge = true
                } else {
                    currentY += 1
                }
            }
            if foundEdge {
                upperBound.insert(XY(x: x, y: currentY))
                lastY = currentY
            } else {
                // if we didn't find an edge, we have an beam-less column
                // reset Y back to the last known Y
                currentY = lastY
            }
        }
        
        // loop through the coordinates along the lower edge of the beam
        // this is looping in ascending order (because it's an array)
        // which means the first one we find that matches is, by definition, the smallest possible one
        for bl in lowerBound {
            // compute the top-right corner
            let tr = XY(x: bl.x + 99, y: bl.y - 99)
            if upperBound.contains(tr) {
                // if the top-right corner lies along the edge, compute the top-left corner and return it
                let tl = XY(x: bl.x, y: bl.y - 99)
                let p2 = (tl.x * 10_000) + tl.y
                return "\(p2)"
            }
        }
        
        fatalError()
    }
    
}
