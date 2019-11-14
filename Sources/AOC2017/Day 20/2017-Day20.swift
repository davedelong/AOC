//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/18/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day20: Day {
    
    class Particle: Hashable {
        static func ==(lhs: Particle, rhs: Particle) -> Bool {
            return lhs.position.x == rhs.position.x && lhs.position.y == rhs.position.y && lhs.position.z == rhs.position.z
        }
        let id: Int
        var position: Vector3
        var velocity: Vector3
        let acceleration: Vector3
        
        var distance: Int { return abs(position.x) + abs(position.y) + abs(position.z) }
        func hash(into hasher: inout Hasher) { hasher.combine(distance) }
        
        init(id: Int, line: String) {
            let pieces = line.components(separatedBy: ", ").map { String($0.dropFirst(3).dropLast()) }
            self.id = id
            position = Vector3(pieces[0])
            velocity = Vector3(pieces[1])
            acceleration = Vector3(pieces[2])
        }
        
        @discardableResult
        func tick() -> Int {
            velocity = velocity + acceleration
            position = position + velocity
            
            return distance
        }
    }
    
    @objc init() { super.init(inputFile: #file) }
    
    func particles() -> Array<Particle> {
        let rawParticles = input.lines.raw
        return rawParticles.enumerated().map { Particle(id: $0, line: $1) }
    }
    
    override func part1() -> String {
        let allParticles = particles()
        var overallClosest = -1
        for _ in 0 ..< 1_000 {
            var closest = 0
            var distance = Int.max
            for p in allParticles {
                let pDistance = p.tick()
                if pDistance < distance {
                    distance = pDistance
                    closest = p.id
                }
            }
            if closest != overallClosest {
                overallClosest = closest
            }
        }
        return "\(overallClosest)"
    }

    override func part2() -> String {
        var remaining = particles()
        var collided = Set<Particle>()
        
        for _ in 0 ..< 1_000 {
            var nonCollided = Set<Particle>()
            
            for p in remaining {
                p.tick()
                if collided.contains(p) { continue }
                if nonCollided.contains(p) {
                    nonCollided.remove(p)
                    collided.insert(p)
                } else {
                    nonCollided.insert(p)
                }
            }
            remaining = Array(nonCollided)
        }

        return "\(remaining.count)"
    }

}
