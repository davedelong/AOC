//
//  Position.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

public typealias Position = Point2
public typealias XY = Point2

public extension Point2 {
    
    static func all(in xRange: ClosedRange<Int>, _ yRange: ClosedRange<Int>) -> Array<Position> {
        return yRange.flatMap { y -> Array<Position> in
            return xRange.map { Position(x: $0, y: y) }
        }
    }
    
    static func edges(of xRange: ClosedRange<Int>, _ yRange: ClosedRange<Int>) -> Set<Position> {
        return Set(
            xRange.map { Position(x: $0, y: yRange.lowerBound) } +
                xRange.map { Position(x: $0, y: yRange.upperBound) } +
                yRange.map { Position(x: xRange.lowerBound, y: $0) } +
                yRange.map { Position(x: xRange.upperBound, y: $0) }
        )
    }
    
    func offset(dx: Int, dy: Int) -> Self {
        return Position(x: x + dx, y: y + dy)
    }
    
    func move(_ heading: Heading, length: Int = 1) -> Position {
        switch heading {
            case .north: return Position(x: x, y: y-length)
            case .south: return Position(x: x, y: y+length)
            case .east: return Position(x: x+length, y: y)
            case .west: return Position(x: x-length, y: y)
            default: fatalError()
        }
    }
    
    func surroundingPositions(includingDiagonals: Bool = false) -> Array<Position> {
        var surround = [
            Position(x: x, y: y-1),
            Position(x: x, y: y+1),
            Position(x: x+1, y: y),
            Position(x: x-1, y: y),
        ]
        if includingDiagonals == true {
            surround.append(contentsOf: [
                Position(x: x-1, y: y-1),
                Position(x: x+1, y: y-1),
                Position(x: x-1, y: y+1),
                Position(x: x+1, y: y+1),
            ])
        }
        return surround
    }
    
    func neighbors() -> Array<Position> {
        return [
            move(.north),
            move(.east),
            move(.south),
            move(.west)
        ]
    }
    
    func polarAngle(to other: Position) -> Double {
        return atan2(Double(other.y - self.y), Double(other.x - self.x))
    }
    
    func heading(to other: Position) -> Heading? {
        guard other.x == self.x || other.y == self.y else { return nil }
        if other == self { return nil }
        if self.x == other.x {
            if other.y < self.y {
                return .north
            } else {
                return .south
            }
        } else {
            if other.x < self.x {
                return .west
            } else {
                return .east
            }
        }
    }
    
    func vector(to other: Position) -> Vector2 {
        if other == self { return .zero }
        let dx = other.x - self.x
        let dy = other.y - self.y
        return Vector2(x: dx, y: dy)
    }
    
    func unitVector(to other: Position) -> Vector2 {
        var v = self.vector(to: other)
        if v.x != 0 { v.x /= abs(v.x) }
        if v.y != 0 { v.y /= abs(v.y) }
        return v
    }
    
}

extension Array where Element: RandomAccessCollection, Element.Index == Int {
    public subscript(key: Position) -> Element.Element? {
        if key.y < 0 { return nil }
        if key.y >= self.count { return nil }
        let row = self[key.y]
        
        if key.x < 0 { return nil }
        if key.x >= row.count { return nil }
        return row[key.x]
    }
}
