//
//  Day17.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day17: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    struct Rock {
        static let order = [hLine, plus, l, vLine, square]
        
        static let hLine = Rock(points: [.init(x: 0, y: 0), .init(x: 1, y: 0), .init(x: 2, y: 0), .init(x: 3, y: 0)])
        static let vLine = Rock(points: [.init(x: 0, y: 0), .init(x: 0, y: 1), .init(x: 0, y: 2), .init(x: 0, y: 3)])
        static let plus = Rock(points: [
            .init(x: 1, y: 0),
            .init(x: 0, y: 1), .init(x: 1, y: 1), .init(x: 2, y: 1),
            .init(x: 1, y: 2)
        ])
        static let l = Rock(points: [
            .init(x: 0, y: 0), .init(x: 1, y: 0), .init(x: 2, y: 0),
            .init(x: 2, y: 1),
            .init(x: 2, y: 2),
        ])
        static let square = Rock(points: [
            .init(x: 0, y: 0), .init(x: 1, y: 0),
            .init(x: 0, y: 1), .init(x: 1, y: 1)
        ])
        
        var points: Array<Point2>
        
        func move(_ heading: Heading) -> Rock {
            return Rock(points: points.map { $0.apply(heading) })
        }
    }

    func part1() async throws -> Part1 {
        return dropRocks(2022).1
    }
    
    func part2() async throws -> Part2 {
        let (grid, maxY) = dropRocks(10_000)
        
        let ints = (0 ... maxY).map { Int(bits: grid.row($0, default: false)) }
        
        print(ints)
        
        var repeatY = 0
        for y in 1 ..< maxY {
            let r = grid.row(y, default: false)
            print(y, r)
            let matches = (y+1 ... maxY).filter({ grid.row($0, default: false) == r })
            
            print("Row \(y) repeats at \(matches)")
        }
        return 0
    }
    
    func dropRocks(_ count: Int) -> (XYGrid<Bool>, Int) {
        let winds = input().characters.compactMap(Heading.init(character:))
        
        var shaft = XYGrid<Bool>()
        for x in 0 ..< 7 {
            shaft[.init(x: x, y: 0)] = true
        }
        
        func rockIsHittingSomething(_ rock: Rock) -> Bool {
            return rock.points.anySatisfy { shaft[$0] == true || $0.x < 0 || $0.x >= 7 }
        }
        
        var infiniteWind = winds.cycled().makeIterator()
        
        var maxY = 0
        var c = 0
        
        for rock in Rock.order.cycled().prefix(count) {
            let startY = maxY + 4
            let startX = 2
            let startV = Heading(x: startX, y: startY)
            
            var r = rock.move(startV)
            
            var fall = false
            
            while true {
                let moved: Rock
                if fall {
                    moved = r.move(.down)
                    if rockIsHittingSomething(moved) { break }
                    
                    // otherwise it fell just fine
                    r = moved
                } else {
                    let h = infiniteWind.next()!
                    moved = r.move(h)
                    if rockIsHittingSomething(moved) == false { r = moved }
                }
                fall.toggle()
            }
            
            for p in r.points { shaft[p] = true }
            let rockMaxY = r.points.max(of: \.y)
            if rockMaxY > maxY {
                maxY = rockMaxY
                print("Rock \(c): \(maxY)")
            }
            
            c += 1
        }
        
        return (shaft, maxY)
    }
}
