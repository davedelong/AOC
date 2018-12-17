//
//  Position.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

public enum Heading: CaseIterable {
    case north, south, west, east
    public func turnLeft() -> Heading {
        switch self {
        case .north: return .west
        case .west: return .south
        case .south: return .east
        case .east: return .north
        }
    }
    public func turnRight() -> Heading {
        switch self {
        case .north: return .east
        case .east: return .south
        case .south: return .west
        case .west: return .north
        }
    }
    public func turnAround() -> Heading {
        switch self {
        case .north: return .south
        case .south: return .north
        case .east: return .west
        case .west: return .east
        }
    }
    public func turn(clockwise: UInt) -> Heading {
        let times = clockwise % 4
        if times == 1 { return turnRight() }
        if times == 2 { return turnAround() }
        if times == 3 { return turnLeft() }
        return self
    }
    
    public func turn(counterClockwise: UInt) -> Heading {
        let times = counterClockwise % 4
        if times == 1 { return turnLeft() }
        if times == 2 { return turnAround() }
        if times == 3 { return turnRight() }
        return self
    }
}

public struct Position: Hashable {
    public static func ==(lhs: Position, rhs: Position) -> Bool { return lhs.x == rhs.x && lhs.y == rhs.y }
    public var hashValue: Int { return x * 1000 + y}
    public let x: Int
    public let y: Int
    
    public var row: Int { return y }
    public var col: Int { return x }
    
    public static func all(in xRange: ClosedRange<Int>, _ yRange: ClosedRange<Int>) -> Array<Position> {
        return yRange.flatMap { y -> Array<Position> in
            return xRange.map { Position(x: $0, y: y) }
        }
    }
    
    public static func extremes<C: Collection>(of positions: C) -> (Position, Position) where C.Element == Position {
        var minX = Int.max
        var maxX = Int.min
        
        var minY = Int.max
        var maxY = Int.min
        
        for p in positions {
            minX = min(minX, p.x)
            minY = min(minY, p.y)
            maxX = max(maxX, p.x)
            maxY = max(maxY, p.y)
        }
        
        return (Position(x: minX, y: minY), Position(x: maxX, y: maxY))
    }
    
    public static func edges(of xRange: ClosedRange<Int>, _ yRange: ClosedRange<Int>) -> Set<Position> {
        return Set(
                xRange.map { Position(x: $0, y: yRange.lowerBound) } +
                xRange.map { Position(x: $0, y: yRange.upperBound) } +
                yRange.map { Position(x: xRange.lowerBound, y: $0) } +
                yRange.map { Position(x: xRange.upperBound, y: $0) }
        )
    }
    
    public func move(_ heading: Heading) -> Position {
        switch heading {
            case .north: return Position(x: x, y: y-1)
            case .south: return Position(x: x, y: y+1)
            case .east: return Position(x: x+1, y: y)
            case .west: return Position(x: x-1, y: y)
        }
    }
    
    public func surroundingPositions(includingDiagonals: Bool = false) -> Array<Position> {
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
    
    public func neighbors() -> Array<Position> {
        return [
            move(.north),
            move(.east),
            move(.south),
            move(.west)
        ]
    }
    
    public func hamiltonianDistance(to other: Position) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
    
    public func closestPosition<C: Collection>(in points: C) -> Position? where C.Element == Position {
        let pointsGroupedByDistance = points.groupedBy { $0.hamiltonianDistance(to: self) }
        guard let shortestDistance = pointsGroupedByDistance.keys.min() else { return nil }
        guard let closestPoints = pointsGroupedByDistance[shortestDistance] else { return nil }
        guard closestPoints.count == 1 else { return nil }
        return closestPoints[0]
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
