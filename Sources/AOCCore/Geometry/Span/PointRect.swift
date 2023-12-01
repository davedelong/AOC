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
    
    public var numberOfPoints: Int { ranges.map(\.count).product! }
    
    public func intersection(with other: Self) -> Self? {
        let intersections = zip(ranges, other.ranges).compactMap { $0.overlap(with: $1) }
        guard intersections.count == Self.numberOfComponents else { return nil }
        return Self(intersections)
    }
    
    public func intersects(_ other: Self) -> Bool {
        return zip(ranges, other.ranges).allSatisfy { $0.overlap(with: $1) != nil }
    }
    
    public func extend(_ int: Int) -> Self {
        if int <= 0 { return self }
        
        return Self(ranges.map { r -> ClosedRange<Int> in
            return (r.lowerBound - int) ... (r.upperBound + int)
        })
    }
    
    public func corners() -> Array<Point> {
        let pieces = ranges.map { [$0.lowerBound, $0.upperBound] }
        let comboCount = 1 << Self.numberOfComponents
        
        return (0 ..< comboCount).map { iteration in
            let bits = iteration.bits.suffix(Self.numberOfComponents)
            let p = zip(pieces, bits).map { $0[$1 ? 0 : 1] }
            return Point(p)
        }
    }
}

extension SpanProtocol {
    
    public func makeIterator() -> SpanIterator<Self> {
        return SpanIterator(span: self)
    }
    
}

public typealias PointRect = PointSpan2

public struct PointSpan2: SpanProtocol {
    public typealias Point = Point2
    public static var numberOfComponents: Int = 2
    
    public var xRange: ClosedRange<Int>
    public var yRange: ClosedRange<Int>
    public var ranges: Array<ClosedRange<Int>> { [xRange, yRange] }
    
    public var width: Int { xRange.count }
    public var height: Int { xRange.count }
    public var count: Int { numberOfPoints }
    
    public var minX: Int {
        get { xRange.lowerBound }
        set { xRange = newValue ... xRange.upperBound }
    }
    public var maxX: Int {
        get { xRange.upperBound }
        set { xRange = xRange.lowerBound ... newValue }
    }
    public var minY: Int {
        get { yRange.lowerBound }
        set { yRange = newValue ... yRange.upperBound }
    }
    public var maxY: Int {
        get { yRange.upperBound }
        set { yRange = yRange.lowerBound ... newValue }
    }
    
    // the "designated" initializer
    public init(_ ranges: Array<ClosedRange<Int>>) {
        self.xRange = ranges[0]; self.yRange = ranges[1]
    }
    
    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init([ClosedRange(extreme: x, length: width), ClosedRange(extreme: y, length: height)])
    }
    
    public init(origin: Position, width: Int, height: Int) {
        self.init([ClosedRange(extreme: origin.x, length: width), ClosedRange(extreme: origin.y, length: height)])
    }
    
    public init(origin: Position, size: Size) {
        self.init([ClosedRange(extreme: origin.x, length: size.width), ClosedRange(extreme: origin.y, length: size.height)])
    }
    
    public init(xRange: Range<Int>, yRange: Range<Int>) {
        self.init([xRange.asClosedRange, yRange.asClosedRange])
    }
    
    public init(xRange: ClosedRange<Int>, yRange: ClosedRange<Int>) {
        self.init([xRange, yRange])
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
