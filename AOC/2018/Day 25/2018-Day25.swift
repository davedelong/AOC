//
//  Day25.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2018 {

    public class Day25: Day {
        
        struct Point: Hashable {
            let x: Int
            let y: Int
            let z: Int
            let t: Int
            
            func distance(to other: Point) -> Int {
                let xD = abs(x - other.x)
                let yD = abs(y - other.y)
                let zD = abs(z - other.z)
                let tD = abs(t - other.t)
                return xD + yD + zD + tD
            }
        }
        
        typealias Constellation = Set<Point>
        
        public init() { super.init(inputSource: .file(#file)) }
        
        lazy var points: Set<Point> = {
            return Set(input.lines.raw.map { line -> Point in
                let ints = line.components(separatedBy: ",").map { Int($0)! }
                return Point(x: ints[0], y: ints[1], z: ints[2], t: ints[3])
            })
        }()
        
        private func constellation(including point: Point, all: Set<Point>) -> Constellation {
            var constellation = Set([point])
            var consider = [point]
            var remaining = all
            remaining.remove(point)
            
            while let point = consider.popLast() {
                let nearby = remaining.filter { $0.distance(to: point) <= 3 }
                remaining.subtract(nearby)
                consider.append(contentsOf: nearby)
                constellation.formUnion(nearby)
            }
            return constellation
        }
        
        override public func part1() -> String {
            var all = points
            
            var constellations = Array<Constellation>()
            while let next = all.randomElement() {
                let c = constellation(including: next, all: all)
                constellations.append(c)
                all.subtract(c)
            }
            
            return "\(constellations.count)"
        }
        
        override public func part2() -> String {
            return ""
        }
        
    }

}
