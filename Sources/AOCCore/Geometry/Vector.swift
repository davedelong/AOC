//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/14/19.
//

import Foundation

public protocol VectorProtocol: Hashable, CustomStringConvertible {
    static var numberOfComponents: Int { get }
    var components: Array<Int> { get }
    init(_ components: Array<Int>)
}

public extension VectorProtocol {
    var description: String {
        return "(" + components.map { "\($0)" }.joined(separator: ", ") + ")"
    }
}

public extension VectorProtocol {
    
    static var zero: Self {
        let ints = Array(repeating: 0, count: self.numberOfComponents)
        return Self.init(ints)
    }
    
    static prefix func -(lhs: Self) -> Self {
        return Self.init(lhs.components.map { -$0 })
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

public struct Vector2: VectorProtocol {
    public static let numberOfComponents = 2
    
    public let components: Array<Int>
    
    public var x: Int { return components[0] }
    public var y: Int { return components[1] }
    public var row: Int { return components[1] }
    public var col: Int { return components[0] }
    
    public init(_ components: Array<Int>) {
        guard components.count == Vector2.numberOfComponents else {
            fatalError("Invalid components provided to \(#function). Expected \(Vector2.numberOfComponents), but got \(components.count)")
        }
        self.components = components
    }
    
    public init(x: Int, y: Int) { self.init([x, y]) }
    public init(row: Int, column: Int) { self.init([column, row]) }
}

public struct Vector3: VectorProtocol {
    public static let numberOfComponents = 3
    
    public var components: Array<Int>
    
    public var x: Int {
        get { return components[0] }
        set { components[0] = newValue }
    }
    public var y: Int {
        get { return components[1] }
        set { components[1] = newValue }
    }
    public var z: Int {
        get { return components[2] }
        set { components[2] = newValue }
    }
    
    public init(_ components: Array<Int>) {
        guard components.count == Vector3.numberOfComponents else {
            fatalError("Invalid components provided to \(#function). Expected \(Vector3.numberOfComponents), but got \(components.count)")
        }
        self.components = components
    }
    
    public init(x: Int, y: Int, z: Int) { self.init([x, y, z]) }
}

public struct Vector4: VectorProtocol {
    public static let numberOfComponents = 4
    
    public let components: Array<Int>
    
    public var x: Int { return components[0] }
    public var y: Int { return components[1] }
    public var z: Int { return components[2] }
    public var t: Int { return components[3] }
    
    public init(_ components: Array<Int>) {
        guard components.count == Vector4.numberOfComponents else {
            fatalError("Invalid components provided to \(#function). Expected \(Vector4.numberOfComponents), but got \(components.count)")
        }
        self.components = components
    }
    
    public init(x: Int, y: Int, z: Int, t: Int) { self.init([x, y, z, t]) }
}
