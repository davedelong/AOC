//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/22/21.
//

import Foundation

public struct Space<P: PointProtocol, T> {
    
    public private(set) var grid = Dictionary<P, T>()
    
    public init() { }
    
    public subscript(key: P) -> T? {
        get { return grid[key] }
        set { grid[key] = newValue }
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
    
    public func makeIterator() -> Dictionary<P, T>.Iterator { grid.makeIterator() }
    
}
