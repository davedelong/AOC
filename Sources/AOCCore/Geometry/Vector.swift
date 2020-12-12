//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/14/19.
//

import Foundation

public protocol VectorProtocol: Hashable, CustomStringConvertible {
    static var numberOfComponents: Int { get }
    var components: Array<Int> { get set }
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
    
    static var unit: Self {
        let ints = Array(repeating: 1, count: self.numberOfComponents)
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
    
    public static let adjacents: Array<Vector2> = [
        Vector2(x: -1, y: -1), Vector2(x: 0, y: -1), Vector2(x: 1, y: -1),
        Vector2(x: -1, y: 0),                        Vector2(x: 1, y: 0),
        Vector2(x: -1, y: 1), Vector2(x: 0, y: 1), Vector2(x: 1, y: 1),
    ]
    
    public var components: Array<Int>
    
    public var x: Int {
        get { components[0] }
        set { components[0] = newValue }
    }
    public var y: Int {
        get { components[1] }
        set { components[1] = newValue }
    }
    public var row: Int {
        get { components[1] }
        set { components[1] = newValue }
    }
    public var col: Int {
        get { components[0] }
        set { components[0] = newValue }
    }
    
    public init(_ components: Array<Int>) {
        guard components.count == Vector2.numberOfComponents else {
            fatalError("Invalid components provided to \(#function). Expected \(Vector2.numberOfComponents), but got \(components.count)")
        }
        self.components = components
    }
    
    public init(x: Int, y: Int) { self.init([x, y]) }
    public init(row: Int, column: Int) { self.init([column, row]) }
    
    public func rotateLeft() -> Vector2 { Vector2(x: -y, y: x) }
    public func rotateRight() -> Vector2 { Vector2(x: y, y: -x) }
    public func rotateLeft(times: Int) -> Vector2 {
        if times < 0 { return rotateRight(times: -times) }
        let mod = times % 4
        if mod == 0 { return self }
        return (0 ..< mod).reduce(into: self) { v, _ in v = v.rotateLeft() }
    }
    public func rotateRight(times: Int) -> Vector2 {
        if times < 0 { return rotateLeft(times: -times) }
        let mod = times % 4
        if mod == 0 { return self }
        return (0 ..< mod).reduce(into: self) { v, _ in v = v.rotateRight() }
    }
    public func rotate(left: Bool, times: Int) -> Vector2 {
        if left {
            return rotateLeft(times: times)
        } else {
            return rotateRight(times: times)
        }
    }
}

public struct Vector3: VectorProtocol {
    public static let numberOfComponents = 3
    
    public var components: Array<Int>
    
    public var x: Int {
        get { components[0] }
        set { components[0] = newValue }
    }
    public var y: Int {
        get { components[1] }
        set { components[1] = newValue }
    }
    public var z: Int {
        get { components[2] }
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
    
    public var components: Array<Int>
    
    public var x: Int {
        get { components[0] }
        set { components[0] = newValue }
    }
    public var y: Int {
        get { components[1] }
        set { components[1] = newValue }
    }
    public var z: Int {
        get { components[2] }
        set { components[2] = newValue }
    }
    public var t: Int {
        get { components[3] }
        set { components[3] = newValue }
    }
    
    public init(_ components: Array<Int>) {
        guard components.count == Vector4.numberOfComponents else {
            fatalError("Invalid components provided to \(#function). Expected \(Vector4.numberOfComponents), but got \(components.count)")
        }
        self.components = components
    }
    
    public init(x: Int, y: Int, z: Int, t: Int) { self.init([x, y, z, t]) }
}
