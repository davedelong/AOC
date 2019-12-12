//
//  Point.swift
//  AOC
//
//  Created by Dave DeLong on 12/24/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public protocol PointProtocol: Hashable, CustomStringConvertible {
    static var numberOfComponents: Int { get }
    var components: Array<Int> { get }
    init(_ components: Array<Int>)
}

public extension PointProtocol {
    
    var description: String {
        return "(" + components.map { $0.description }.joined(separator: ", ") + ")"
    }
    
}

public extension PointProtocol {
    
    static var zero: Self {
        let ints = Array(repeating: 0, count: self.numberOfComponents)
        return Self.init(ints)
    }
    
    static func +<V: VectorProtocol>(lhs: Self, rhs: V) -> Self {
        guard numberOfComponents == V.numberOfComponents else {
            fatalError("Cannot add a Vector\(V.numberOfComponents) to a Point\(numberOfComponents)")
        }
        let new = zip(lhs.components, rhs.components).map { $0 + $1 }
        return Self.init(new)
    }
    
    static func -<V: VectorProtocol>(lhs: Self, rhs: V) -> Self {
        return lhs + -rhs
    }
    
    static func +(lhs: Self, rhs: Self) -> Self {
        let new = zip(lhs.components, rhs.components).map { $0 + $1 }
        return Self.init(new)
    }
    
    static func -(lhs: Self, rhs: Self) -> Self {
        let new = zip(lhs.components, rhs.components).map { $0 - $1 }
        return Self.init(new)
    }
    
    static func *(lhs: Self, rhs: Int) -> Self {
        let new = lhs.components.map { $0 * rhs }
        return Self.init(new)
    }
    
    func manhattanDistance(to other: Self) -> Int {
        let pairs = zip(components, other.components)
        return pairs.reduce(0) { $0 + abs($1.0 - $1.1) }
    }
    
    init(_ source: String) {
        let matches = Regex.integers.matches(in: source)
        let ints = matches.compactMap { match -> Int? in
            guard let piece = match[1] else { return nil }
            return Int(piece)
        }
        self.init(ints)
    }
}

public struct Point2: PointProtocol {
    public static let numberOfComponents = 2
    
    public let components: Array<Int>
    
    public var x: Int { return components[0] }
    public var y: Int { return components[1] }
    public var row: Int { return components[1] }
    public var col: Int { return components[0] }
    
    public init(_ components: Array<Int>) {
        guard components.count == Point2.numberOfComponents else {
            fatalError("Invalid components provided to \(#function). Expected \(Point2.numberOfComponents), but got \(components.count)")
        }
        self.components = components
    }
    
    public init(x: Int, y: Int) { self.init([x, y]) }
    public init(row: Int, column: Int) { self.init([column, row]) }
}

public struct Point3: PointProtocol {
    public static let numberOfComponents = 3
    
    public let components: Array<Int>
    
    public var x: Int { return components[0] }
    public var y: Int { return components[1] }
    public var z: Int { return components[2] }
    
    public init(_ components: Array<Int>) {
        guard components.count == Point3.numberOfComponents else {
            fatalError("Invalid components provided to \(#function). Expected \(Point3.numberOfComponents), but got \(components.count)")
        }
        self.components = components
    }
    
    public init(x: Int, y: Int, z: Int) { self.init([x, y, z]) }
}

public struct Point4: PointProtocol {
    public static let numberOfComponents = 4
    
    public let components: Array<Int>
    
    public var x: Int { return components[0] }
    public var y: Int { return components[1] }
    public var z: Int { return components[2] }
    public var t: Int { return components[3] }
    
    public init(_ components: Array<Int>) {
        guard components.count == Point4.numberOfComponents else {
            fatalError("Invalid components provided to \(#function). Expected \(Point4.numberOfComponents), but got \(components.count)")
        }
        self.components = components
    }
    
    public init(x: Int, y: Int, z: Int, t: Int) { self.init([x, y, z, t]) }
}
