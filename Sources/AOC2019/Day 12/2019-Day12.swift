//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/11/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day12: Day {
    
    struct State: Hashable {
        let p: Vector4
        let v: Vector4
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    override func part1() -> String {
        
        var positions = [
            Vector3(x: -3, y: 15, z: -11),
            Vector3(x: 3, y: 13, z: -19),
            Vector3(x: -13, y: 18, z: -2),
            Vector3(x: 6, y: 0, z: -1),
        ]
        
        var velocities = [
            Vector3.zero,
            Vector3.zero,
            Vector3.zero,
            Vector3.zero,
        ]
        
        for _ in 0 ..< 1000 {
            // first, apply gravity to velocities
        
            var deltas = [
                Vector3.zero,
                Vector3.zero,
                Vector3.zero,
                Vector3.zero,
            ]
            
            var iterator = CombinationIterator(positions.indices, choose: 2)
            while let pair = iterator.next() {
                let m1 = positions[pair[0]]
                let m2 = positions[pair[1]]
                if m1.x < m2.x {
                    deltas[pair[0]].x += 1
                    deltas[pair[1]].x -= 1
                } else if m1.x > m2.x {
                    deltas[pair[0]].x -= 1
                    deltas[pair[1]].x += 1
                }
                
                if m1.y < m2.y {
                    deltas[pair[0]].y += 1
                    deltas[pair[1]].y -= 1
                } else if m1.y > m2.y {
                    deltas[pair[0]].y -= 1
                    deltas[pair[1]].y += 1
                }
                
                if m1.z < m2.z {
                    deltas[pair[0]].z += 1
                    deltas[pair[1]].z -= 1
                } else if m1.z > m2.z {
                    deltas[pair[0]].z -= 1
                    deltas[pair[1]].z += 1
                }
            }
            velocities = velocities.enumerated().map { $1 + deltas[$0] }
            positions = positions.enumerated().map { $1 + velocities[$0] }
        }
        
        let totalEnergy = zip(velocities, positions).map { (v, p) -> UInt in
            let pE = p.components.map { $0.magnitude }.sum()
            let kE = v.components.map { $0.magnitude }.sum()
            return pE * kE
        }.sum()
        
        return "\(totalEnergy)"
    }
    
    override func part2() -> String {
        
        var positions = [
            Vector3(x: -3, y: 15, z: -11),
            Vector3(x: 3, y: 13, z: -19),
            Vector3(x: -13, y: 18, z: -2),
            Vector3(x: 6, y: 0, z: -1),
        ]
        
//        positions = [
//            Vector3(x: -8, y: -10, z: 0),
//            Vector3(x: 5, y: 5, z: 10),
//            Vector3(x: 2, y: -7, z: 3),
//            Vector3(x: 9, y: -8, z: -3),
//        ]
        
        var velocities = [
            Vector3.zero,
            Vector3.zero,
            Vector3.zero,
            Vector3.zero,
        ]
        
        var axisPeriods: Array<UInt?> = [nil, nil, nil]
        var seen = [
            Set<State>(),
            Set<State>(),
            Set<State>(),
        ]
        
        seen[0].insert(State(p: Vector4(positions.map { $0.x }), v: Vector4(positions.map { $0.x })))
        seen[1].insert(State(p: Vector4(positions.map { $0.y }), v: Vector4(positions.map { $0.y })))
        seen[2].insert(State(p: Vector4(positions.map { $0.z }), v: Vector4(positions.map { $0.z })))
        
        var steps: UInt = 0
        repeat {
            // first, apply gravity to velocities
        
            var deltas = [
                Vector3.zero,
                Vector3.zero,
                Vector3.zero,
                Vector3.zero,
            ]
            
            var iterator = CombinationIterator(positions.indices, choose: 2)
            while let pair = iterator.next() {
                let m1 = positions[pair[0]]
                let m2 = positions[pair[1]]
                if m1.x < m2.x {
                    deltas[pair[0]].x += 1
                    deltas[pair[1]].x -= 1
                } else if m1.x > m2.x {
                    deltas[pair[0]].x -= 1
                    deltas[pair[1]].x += 1
                }
                
                if m1.y < m2.y {
                    deltas[pair[0]].y += 1
                    deltas[pair[1]].y -= 1
                } else if m1.y > m2.y {
                    deltas[pair[0]].y -= 1
                    deltas[pair[1]].y += 1
                }
                
                if m1.z < m2.z {
                    deltas[pair[0]].z += 1
                    deltas[pair[1]].z -= 1
                } else if m1.z > m2.z {
                    deltas[pair[0]].z -= 1
                    deltas[pair[1]].z += 1
                }
            }
            velocities = velocities.enumerated().map { $1 + deltas[$0] }
            positions = positions.enumerated().map { $1 + velocities[$0] }
            
            for axis in 0 ..< 3 {
                guard axisPeriods[axis] == nil else { continue }
                let p = Vector4(positions.map { $0.components[axis] })
                let v = Vector4(velocities.map { $0.components[axis] })
                let state = State(p: p, v: v)
                if seen[axis].contains(state) {
                    axisPeriods[axis] = steps
                } else {
                    seen[axis].insert(state)
                }
            }
            
            steps += 1
        } while axisPeriods.any(satisfy: { $0 == nil })
        
        // get the least common multiple of the axes' periods
        let periods = axisPeriods.compactMap { $0 }
        let total = lcm(of: periods)
        
        return "\(total)"
    }
    
}
