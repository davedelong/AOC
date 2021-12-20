//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/17/21.
//

import Foundation

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
