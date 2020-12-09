//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/11/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day12: Day {
    
    struct Snapshot: Hashable {
        let p: Array<Int>
        let v: Array<Int>
    }
    
    struct System {
        var positions: Array<Point3> = [Point3(x: -3, y: 15, z: -11),
                                        Point3(x: 3, y: 13, z: -19),
                                        Point3(x: -13, y: 18, z: -2),
                                        Point3(x: 6, y: 0, z: -1)]
        var velocities: Array<Vector3> = [.zero, .zero, .zero, .zero]
        
        var totalEnergy: UInt {
            return zip(velocities, positions).map { (v, p) -> UInt in
                let pE = p.components.map { $0.magnitude }.sum
                let kE = v.components.map { $0.magnitude }.sum
                return pE * kE
            }.sum
        }
        
        func snapshot(axis: Int) -> Snapshot {
            return Snapshot(p: positions.map { $0.components[axis] },
                            v: velocities.map { $0.components[axis] })
        }
        
        mutating func step() {
            var deltas: Array<Vector3> = [.zero, .zero, .zero, .zero]
            
            for pair in positions.indices.combinations(ofCount: 2) {
                let m1 = positions[pair[0]]
                let m2 = positions[pair[1]]
                
                for axis in 0 ..< 3 {
                    if m1.components[axis] < m2.components[axis] {
                        deltas[pair[0]].components[axis] += 1
                        deltas[pair[1]].components[axis] -= 1
                    } else if m1.components[axis] > m2.components[axis] {
                        deltas[pair[0]].components[axis] -= 1
                        deltas[pair[1]].components[axis] += 1
                    }
                }
            }
            
            velocities = velocities.enumerated().map { $1 + deltas[$0] }
            positions = positions.enumerated().map { $1 + velocities[$0] }
        }
    }
    
    override func run() -> (String, String) {
        var p1: String? = nil
        var p2: String? = nil
        
        var s = System()
        
        var snapshots: Array<Set<Snapshot>> = [[], [], []]
        var periods: Array<UInt?> = [nil, nil, nil]
        
        var stepCount: UInt = 0
        while p1 == nil || p2 == nil {
            
            for axis in 0 ..< 3 {
                guard periods[axis] == nil else { continue }
                let snapshot = s.snapshot(axis: axis)
                if snapshots[axis].contains(snapshot) {
                    periods[axis] = stepCount
                } else {
                    snapshots[axis].insert(snapshot)
                }
            }
            
            if stepCount == 1000 {
                p1 = "\(s.totalEnergy)"
            }
            
            if periods.allSatisfy({ $0 != nil }) {
                let p = periods.compacted
                p2 = "\(lcm(of: p))"
            }
            
            s.step()
            
            stepCount += 1
        }
        
        return (p1!, p2!)
    }
    
}
