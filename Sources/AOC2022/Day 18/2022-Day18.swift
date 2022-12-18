//
//  Day18.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day18: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    struct Face: Hashable {
        let point: Point3
        let side: Vector3
    }

    func run() async throws -> (Part1, Part2) {
        var space = Space<Point3, Bool>()
        
        let drops = input().lines.map { Point3($0.integers) }
        for drop in drops {
            space[drop] = true
        }
        
        let xyzVectors = Point3.orthogonalVectors()
        
        let exposedFaces = drops.flatMap { d in
            let faces = xyzVectors.map { Face(point: d, side: $0) }
            
            return faces.filter { f in
                let p = f.point.apply(f.side)
                return space[p] == nil
            }
        }
        
        let p1 = exposedFaces.count
        
        let extremes = space.span.extend(1)
        
        var pointsToConsider = extremes.corners()
        var considered = Set<Point3>()
        
        // true = lava
        // false = confirmed air
        let air = false
        while pointsToConsider.isNotEmpty {
            let next = pointsToConsider.removeFirst()
            considered.insert(next)
            
            // first check to see if we've already seen this coordinate
            if space[next] != nil { continue }
            
            // space is void; fill it with air
            space[next] = air
            let surrounding = next.orthogonalNeighbors().filter { extremes.contains($0) }
            let unconsidered = surrounding.filter { considered.contains($0) == false }
            pointsToConsider.append(contentsOf: unconsidered)
        }
        
        let p2_a = exposedFaces.count(where: { face in
            let n = face.point.move(face.side)
            return space[n] == air
        })
        
        let interiorFaces = drops.sum(of: { d in
            return xyzVectors.count(where: {
                let p = d.apply($0)
                return space[p] == nil
            })
        })
        let p2 = exposedFaces.count - interiorFaces
        
        return (p1, p2)
    }

}
