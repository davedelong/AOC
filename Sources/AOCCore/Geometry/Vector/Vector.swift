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
    
    static func assertComponents(_ components: Array<Int>, caller: StaticString = #function) {
        if components.count != numberOfComponents {
            fatalError("Invalid components provided to \(caller). Expected \(numberOfComponents), but got \(components.count)")
        }
    }
    
    var description: String {
        return "(" + components.map { "\($0)" }.joined(separator: ", ") + ")"
    }
    
    var magnitude: Self { return Self(components.map(abs)) }
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
    
    internal static func adjacents(orthogonalOnly: Bool, includingSelf: Bool, length: Int = 3) -> Array<Self> {
        let combos = self.combos(count: Self.numberOfComponents, length: length)
        var all = combos.map(Self.init(_:))
        if orthogonalOnly { all = all.filter(\.isOrthogonal) }
        if includingSelf == false { all = all.filter(\.isNotZero) }
        return all
    }
    
    private static func combos(count: Int, length: Int) -> Array<Array<Int>> {
        guard count > 0 else { return [] }
        let remainders = combos(count: count-1, length: length)
        
        let lengthRange = (-length/2) ... (-length/2 + length - 1)
        if remainders.isEmpty { return Array(lengthRange).map { [$0] } }
        
        return lengthRange.flatMap { l -> Array<Array<Int>> in
            return remainders.map { [l] + $0 }
        }
    }
    
    var isZero: Bool { components.allSatisfy { $0 == 0 } }
    var isNotZero: Bool { !isZero }
    
    var isOrthogonal: Bool {
        return components.count(where: { $0 != 0 }) <= 1
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
    
    func unit() -> Self {
        return Self(components.map {
            if $0 == 0 { return $0 }
            return $0 / Int($0.magnitude)
        })
    }
}

public struct Vector2: VectorProtocol {
    public static let numberOfComponents = 2
    
    public static let adjacents: Array<Vector2> = [
        Vector2(x: -1, y: -1), Vector2(x: 0, y: -1), Vector2(x: 1, y: -1),
        Vector2(x: -1, y: 0),                        Vector2(x: 1, y: 0),
        Vector2(x: -1, y: 1), Vector2(x: 0, y: 1), Vector2(x: 1, y: 1),
    ]
    
    public var components: Array<Int> {
        get { [x, y] }
        set { x = newValue[0]; y = newValue[1] }
    }
    
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
    
    public init(_ components: Array<Int>) {
        Self.assertComponents(components)
        self.init(x: components[0], y: components[1])
    }
    
    public init(x: Int, y: Int) { self.x = x; self.y = y }
    public init(row: Int, column: Int) { self.init(x: column, y: row) }
    
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
    
    public var components: Array<Int> {
        get { [x, y, z] }
        set { x = newValue[0]; y = newValue[1]; z = newValue[2] }
    }
    
    public var x: Int
    public var y: Int
    public var z: Int
    
    public init(_ components: Array<Int>) {
        Self.assertComponents(components)
        self.init(x: components[0], y: components[1], z: components[2])
    }
    
    public init(x: Int, y: Int, z: Int) { self.x = x; self.y = y; self.z = z }
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
        Self.assertComponents(components)
        self.components = components
    }
    
    public init(x: Int, y: Int, z: Int, t: Int) { self.init([x, y, z, t]) }
}
