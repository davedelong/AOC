//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/17/21.
//

import Foundation

public protocol SpanProtocol: Hashable, CustomStringConvertible, Sequence {
    associatedtype Point: PointProtocol
    static var numberOfComponents: Int { get }
    var ranges: Array<ClosedRange<Int>> { get }
    init(_ ranges: Array<ClosedRange<Int>>)
}

extension SpanProtocol {
    
    public var origin: Point {
        return Point(ranges.map(\.lowerBound))
    }
    
    public var description: String {
        return "(" + ranges.map(\.description).joined(separator: ", ") + ")"
    }
    
    public func contains(_ p: Point) -> Bool {
        return zip(ranges, p.components).allSatisfy { $0.contains($1) }
    }
    
    public var numberOfPoints: Int { ranges.map(\.count).product }
    
    public func intersection(with other: Self) -> Self? {
        let intersections = zip(ranges, other.ranges).compactMap { $0.overlap(with: $1) }
        guard intersections.count == Self.numberOfComponents else { return nil }
        return Self(intersections)
    }
    
    public func intersects(_ other: Self) -> Bool {
        return zip(ranges, other.ranges).allSatisfy { $0.overlap(with: $1) != nil }
    }
}

extension SpanProtocol {
    
    public func makeIterator() -> SpanIterator<Self> {
        return SpanIterator(span: self)
    }
    
}

public struct PointSpan2: SpanProtocol {
    public typealias Point = Point2
    public static var numberOfComponents: Int = 2
    
    public var xRange: ClosedRange<Int>
    public var yRange: ClosedRange<Int>
    public var ranges: Array<ClosedRange<Int>> { [xRange, yRange] }
    
    public init(_ ranges: Array<ClosedRange<Int>>) {
        self.xRange = ranges[0]; self.yRange = ranges[1]
    }
}

public struct PointSpan3: SpanProtocol {
    public typealias Point = Point3
    public static var numberOfComponents: Int = 3
    
    public var xRange: ClosedRange<Int>
    public var yRange: ClosedRange<Int>
    public var zRange: ClosedRange<Int>
    public var ranges: Array<ClosedRange<Int>> { [xRange, yRange, zRange] }
    
    public init(_ ranges: Array<ClosedRange<Int>>) {
        self.xRange = ranges[0]; self.yRange = ranges[1]; self.zRange = ranges[2]
    }
}

public struct PointSpan4: SpanProtocol {
    public typealias Point = Point4
    public static var numberOfComponents: Int = 4
    
    public var xRange: ClosedRange<Int>
    public var yRange: ClosedRange<Int>
    public var zRange: ClosedRange<Int>
    public var tRange: ClosedRange<Int>
    public var ranges: Array<ClosedRange<Int>> { [xRange, yRange, zRange, tRange] }
    
    public init(_ ranges: Array<ClosedRange<Int>>) {
        self.xRange = ranges[0]; self.yRange = ranges[1]; self.zRange = ranges[2]; self.tRange = ranges[3]
    }
}

public struct PointRect: Hashable {
    public var origin: Position
    public var width: Int
    public var height: Int
    
    public var count: Int { width * height }
    
    private var xRange: Range<Int> { origin.x ..< (origin.x + width) }
    private var yRange: Range<Int> { origin.y ..< (origin.y + height) }
    
    public var minX: Int { xRange.lowerBound }
    public var minY: Int { yRange.lowerBound }
    public var maxX: Int { xRange.upperBound - 1 }
    public var maxY: Int { yRange.upperBound - 1 }
    
    // the "designated" initializer
    // because this has the logic about normalizing width + height to always be positive
    private init(x: Int, y: Int, w: Int, h: Int) {
        var oX = x
        var oY = y
        var nW = w
        var nH = h
        
        if nW < 0 {
            oX += nW
            nW *= -1
        }
        if nH < 0 {
            oY += nH
            nH *= -1
        }
        
        self.origin = Position(x: oX, y: oY)
        self.width = nW
        self.height = nH
    }
    
    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(x: x, y: y, w: width, h: height)
    }
    
    public init(origin: Position, width: Int, height: Int) {
        self.init(x: origin.x, y: origin.y, w: width, h: height)
    }
    
    public init(origin: Position, size: Size) {
        self.init(x: origin.x, y: origin.y, w: size.width, h: size.height)
    }
    
    public init(xRange: Range<Int>, yRange: Range<Int>) {
        self.init(x: xRange.lowerBound, y: yRange.lowerBound, w: xRange.count, h: yRange.count)
    }
    
    public init(xRange: ClosedRange<Int>, yRange: ClosedRange<Int>) {
        self.init(x: xRange.lowerBound, y: yRange.lowerBound, w: xRange.count, h: yRange.count)
    }
    
    public func contains(_ point: Position) -> Bool {
        return xRange.contains(point.x) && yRange.contains(point.y)
    }
}

extension PointRect: Sequence {
    
    public struct Iterator: IteratorProtocol {
        private var point: Position
        private let rect: PointRect
        
        public init(rect: PointRect) {
            self.rect = rect
            self.point = rect.origin.offset(dx: -1, dy: 0)
        }
        
        public mutating func next() -> Position? {
            var next = point.offset(dx: 1, dy: 0)
            if rect.contains(next) == false {
                next = Position(x: rect.origin.x, y: next.y + 1)
            }
            point = next
            if rect.contains(next) == false { return nil }
            return next
        }
    }
    
    public func makeIterator() -> Iterator {
        return Iterator(rect: self)
    }
    
}

public struct SpanIterator<S: SpanProtocol>: IteratorProtocol {
    private let ranges: Array<ClosedRange<Int>>
    private var rangeOffsets: Array<Int>
    
    public init(span: S) {
        self.ranges = span.ranges
        self.rangeOffsets = Array(repeating: 0, count: S.numberOfComponents)
    }
    
    public mutating func next() -> S.Point? {
        let components = zip(ranges, rangeOffsets).compactMap { r, o -> Int? in
            let e = r.lowerBound + o
            guard r.contains(e) else { return nil }
            return e
        }
        guard components.count == S.Point.numberOfComponents else { return nil }
        defer { increment() }
        return S.Point(components)
    }
    
    private mutating func increment() {
        for c in 0 ..< S.numberOfComponents {
            rangeOffsets[c] += 1
            if rangeOffsets[c] >= ranges[c].count {
                rangeOffsets[c] = 0
            } else {
                return
            }
        }
        // if we ever get here, we've incremented everything
        rangeOffsets = Array(repeating: -1, count: S.numberOfComponents)
    }
}
