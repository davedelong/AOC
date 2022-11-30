//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/22/21.
//

import Foundation

public typealias Position = Point2
public typealias XY = Point2

public struct Point2: PointProtocol {
    public typealias Vector = Vector2
    public typealias Span = PointSpan2
    public static let numberOfComponents = 2
    
    public var components: Array<Int> { [x, y] }
    
    public var x: Int
    public var y: Int
    
    public var row: Int {
        get { y }
        set { y = newValue }
    }
    
    public var col: Int {
        get { x }
        set { x = newValue }
    }
    
    public init(x: Int, y: Int) {
        self.x = x; self.y = y
    }
    
    public init(_ components: Array<Int>) {
        guard components.count == Point2.numberOfComponents else {
            fatalError("Invalid components provided to \(#function). Expected \(Point2.numberOfComponents), but got \(components.count)")
        }
        self.init(x: components[0], y: components[1])
    }
    
    public init(row: Int, column: Int) { self.init(x: column, y: row) }
}

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
    
    func polarAngle(to other: Position) -> Double {
        return atan2(Double(other.y - self.y), Double(other.x - self.x))
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
