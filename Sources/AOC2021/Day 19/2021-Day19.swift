//
//  Day19.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

class Day19: Day {
    
    typealias Transform3D = (Point3) -> Point3
    
    let allTransforms: Array<Transform3D> = [
        { Point3(x:  $0.x, y:  $0.y, z:  $0.z) },
        { Point3(x:  $0.x, y:  $0.z, z: -$0.y) },
        { Point3(x:  $0.x, y: -$0.y, z: -$0.z) },
        { Point3(x:  $0.x, y: -$0.z, z:  $0.y) },
        { Point3(x:  $0.y, y:  $0.x, z: -$0.z) },
        { Point3(x:  $0.y, y:  $0.z, z:  $0.x) },
        { Point3(x:  $0.y, y: -$0.x, z:  $0.z) },
        { Point3(x:  $0.y, y: -$0.z, z: -$0.x) },
        { Point3(x:  $0.z, y:  $0.x, z:  $0.y) },
        { Point3(x:  $0.z, y:  $0.y, z: -$0.x) },
        { Point3(x:  $0.z, y: -$0.x, z: -$0.y) },
        { Point3(x:  $0.z, y: -$0.y, z:  $0.x) },
        { Point3(x: -$0.x, y:  $0.y, z: -$0.z) },
        { Point3(x: -$0.x, y:  $0.z, z:  $0.y) },
        { Point3(x: -$0.x, y: -$0.y, z:  $0.z) },
        { Point3(x: -$0.x, y: -$0.z, z: -$0.y) },
        { Point3(x: -$0.y, y:  $0.x, z:  $0.z) },
        { Point3(x: -$0.y, y:  $0.z, z: -$0.x) },
        { Point3(x: -$0.y, y: -$0.x, z: -$0.z) },
        { Point3(x: -$0.y, y: -$0.z, z:  $0.x) },
        { Point3(x: -$0.z, y:  $0.x, z: -$0.y) },
        { Point3(x: -$0.z, y:  $0.y, z:  $0.x) },
        { Point3(x: -$0.z, y: -$0.x, z:  $0.y) },
        { Point3(x: -$0.z, y: -$0.y, z: -$0.x) },
    ]
    
    struct Scanner {
        let scannerNumber: Int
        var beacons: Set<Point3>
        
        func vectors(from point: Point3) -> Array<Vector3> {
            return beacons.compactMap { p -> Vector3? in
                guard p != point else { return nil }
                return p.vector(to: point)
            }
        }
        
        var allVectors: Set<Vector3> {
            return Set(beacons.flatMap { self.vectors(from: $0) })
        }
        
        func apply(_ transform: Transform3D) -> Scanner {
            return Scanner(scannerNumber: scannerNumber, beacons: Set(beacons.map(transform)))
        }
    }
    
    /*
     for the starting cube we want to take the most extreme elements in each x/y/z axis
     those 6 will be asked to compute vectors to their neighbors in the space
     
     then we'll go through all the other cubes and see if they have any point that has
     the same vectors to neighbors
     
     if they do, then we need to figure out how to rotate the cube to match the orientation
     of the intial cube
     */
    lazy var parsedScanners: Array<Scanner> = {
        var final = Array<Scanner>()
        
        for line in input().lines {
            if line.raw.hasPrefix("---") {
                let number = line.integers[0]
                final.append(Scanner(scannerNumber: number, beacons: []))
            } else if line.raw.isEmpty == false {
                let integers = line.integers
                let point = Point3(integers)
                var last = final.removeLast()
                last.beacons.insert(point)
                final.append(last)
            }
        }
        
        return final
    }()

    func run() async throws -> (Int, Int) {
        var scanners = parsedScanners
        var scannerLocations = Set<Point3>()
        
        var world = scanners.removeFirst()
        scannerLocations.insert(.zero)
        
        while let nextUnknownScanner = scanners.popFirst() {
            
            var didMatch = false
            
eachExtreme: for knownBeacon in world.beacons {
                let worldVectors = Set(world.vectors(from: knownBeacon))
                
    eachBeacon: for point in nextUnknownScanner.beacons {
                        // start flipping this scanner around to see if we can get *actually* matching vectors
     eachTransform: for transform in allTransforms {
                        let newPoint = transform(point)
                        let transformedScanner = nextUnknownScanner.apply(transform)
                        let transformedVectors = Set(transformedScanner.vectors(from: newPoint))
                        let actualIntersection = worldVectors.intersection(transformedVectors)
                        if actualIntersection.count >= 6 {
                            // OMG I THINK THEY MATCH
                            print("Matched \(actualIntersection.count + 1) beacons from scanner \(transformedScanner.scannerNumber)")
                            
                            didMatch = true
                            let offset = knownBeacon.vector(to: newPoint)
                            let translatedBeacons = transformedScanner.beacons.map { $0.apply(offset) }
                            world.beacons.formUnion(translatedBeacons)
                            scannerLocations.insert(.zero.apply(offset))
                            break eachExtreme
                        }
                    }
                }
            }
            if didMatch == false {
                // throw it on the end and we'll get back to it
                scanners.append(nextUnknownScanner)
            }
        }
        
        let p1 = world.beacons.count
        
        let p2 = scannerLocations.permutations(ofCount: 2).map { $0[0].manhattanDistance(to: $0[1]) }.max()!
        
        return (p1, p2)
    }

}
