//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/22/21.
//

import Foundation

public struct Space<P: PointProtocol, T> {
    public typealias Storage = Dictionary<P, T>
    
    public private(set) var grid = Storage()
    
    public init() { }
    
    public subscript(key: P) -> T? {
        get { return grid[key] }
        set { grid[key] = newValue }
    }
    
    public subscript(key: P, default missing: @autoclosure () -> T) -> T {
        self[key] ?? missing()
    }
    
    public var span: P.Span {
        let (l, u) = P.extremes(of: grid.keys)
        let ranges = zip(l.components, u.components).map { $0 ... $1 }
        return P.Span(ranges)
    }
}


extension Space: Equatable where T: Equatable {
    public static func ==(lhs: XYGrid<T>, rhs: XYGrid<T>) -> Bool { return lhs.grid == rhs.grid }
}

extension Space: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(grid)
    }
}

extension Space: Sequence {
    public func makeIterator() -> Storage.Iterator { grid.makeIterator() }
}

extension Space: Collection {
    public subscript(position: Storage.Index) -> Storage.Element {
        get { grid[position] }
    }
    
    public var startIndex: Storage.Index { grid.startIndex }
    public var endIndex: Storage.Index { grid.endIndex }
    public typealias Index = Storage.Index

    public var count: Int { grid.count }
    public func index(after i: Storage.Index) -> Storage.Index { grid.index(after: i) }
    public func index(_ i: Storage.Index, offsetBy distance: Int) -> Storage.Index { grid.index(i, offsetBy: distance) }
    public func distance(from start: Storage.Index, to end: Storage.Index) -> Int { grid.distance(from: start, to: end) }
}
