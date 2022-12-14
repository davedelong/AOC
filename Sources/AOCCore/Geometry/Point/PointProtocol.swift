//
//  Point.swift
//  AOC
//
//  Created by Dave DeLong on 12/24/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public protocol PointProtocol: Hashable, CustomStringConvertible {
    associatedtype Vector: VectorProtocol
    associatedtype Span: SpanProtocol where Span.Point == Self
    
    static var numberOfComponents: Int { get }
    
    var components: Array<Int> { get set }
    init(_ components: Array<Int>)
}

public extension PointProtocol {
    
    static func assertComponents(_ components: Array<Int>, caller: StaticString = #function) {
        if components.count != numberOfComponents {
            fatalError("Invalid components provided to \(caller). Expected \(numberOfComponents), but got \(components.count)")
        }
    }
    
    var description: String {
        return "(" + components.map(\.description).joined(separator: ", ") + ")"
    }
    
}

public extension PointProtocol {
    
    private static func all<C: Collection>(between lower: C, and upper: C) -> Array<Array<Int>> where C.Element == Int {
        guard lower.count == upper.count else { return [] }
        guard let l = lower.first, let u = upper.first else { return [] }
        
        let remainder = all(between: lower.dropFirst(), and: upper.dropFirst())
        
        let range = min(l, u)...max(l, u)
        if remainder.isEmpty { return range.map { [$0] } }
        
        return range.flatMap { prefix -> Array<Array<Int>> in
            remainder.map { [prefix] + $0 }
        }
    }
    
    static func all(between lower: Self, and upper: Self) -> Array<Self> {
        let combos = all(between: lower.components, and: upper.components)
        return combos.map(Self.init(_:))
    }
    
    static func extremes<C: Collection>(of positions: C) -> (Self, Self) where C.Element == Self {
        var mins = Array(repeating: Int.max, count: numberOfComponents)
        var maxs = Array(repeating: Int.min, count: numberOfComponents)
        
        for p in positions {
            for i in 0 ..< numberOfComponents {
                mins[i] = min(mins[i], p.components[i])
                maxs[i] = max(maxs[i], p.components[i])
            }
        }
        
        return (Self.init(mins), Self.init(maxs))
    }
    
    static var zero: Self {
        let ints = Array(repeating: 0, count: self.numberOfComponents)
        return Self.init(ints)
    }
    
    static func +(lhs: Self, rhs: Vector) -> Self {
        guard numberOfComponents == Vector.numberOfComponents else {
            fatalError("Cannot add a Vector\(Vector.numberOfComponents) to a Point\(numberOfComponents)")
        }
        let new = zip(lhs.components, rhs.components).map { $0 + $1 }
        return Self.init(new)
    }
    
    static func +=(lhs: inout Self, rhs: Vector) {
        lhs = lhs + rhs
    }
    
    static func -(lhs: Self, rhs: Vector) -> Self {
        return lhs + -rhs
    }
    
    static func -=(lhs: inout Self, rhs: Vector) {
        lhs = lhs - rhs
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
    
    static func *=(lhs: inout Self, rhs: Int) {
        lhs = lhs * rhs
    }
    
    init<S: StringProtocol>(_ source: S) {
        let matches = Regex.integers.matches(in: source.description)
        let ints = matches.compactMap { match -> Int? in
            guard let piece = match[1] else { return nil }
            return Int(piece)
        }
        self.init(ints)
    }
    
    func manhattanDistance(to other: Self) -> Int {
        let pairs = zip(components, other.components)
        return pairs.reduce(0) { $0 + abs($1.0 - $1.1) }
    }
    
    func allNeighbors() -> Array<Self> {
        let vectors = Vector.adjacents(orthogonalOnly: false, includingSelf: false)
        return vectors.map { self.apply($0) }
    }
    
    func orthogonalNeighbors() -> Array<Self> {
        let vectors = Vector.adjacents(orthogonalOnly: true, includingSelf: false)
        return vectors.map { self.apply($0) }
    }
    
    func neighbors(includingDiagonals: Bool) -> Array<Self> {
        let vectors = Vector.adjacents(orthogonalOnly: !includingDiagonals, includingSelf: false)
        return vectors.map { self.apply($0) }
    }
    
    func neighbors() -> Array<Self> { orthogonalNeighbors() }
    func allSurroundingPoints() -> Array<Self> { allNeighbors() }
    func surroundingPositions(includingDiagonals: Bool = false) -> Array<Self> { neighbors(includingDiagonals: includingDiagonals) }
    
    func centeredWindow(length: Int) -> Array<Self> {
        let vectors = Vector.adjacents(orthogonalOnly: false, includingSelf: true, length: length)
        return vectors.map { self.apply($0) }
    }
    
    func closestPosition<C: Collection>(in points: C) -> Self? where C.Element == Self {
        
        var closest: Self?
        var distance = Int.max
        
        for other in points {
            let d = manhattanDistance(to: other)
            if d < distance {
                closest = other
                distance = d
            }
        }
        
        return closest
    }
    
    func unitVector(to other: Self) -> Vector {
        return self.vector(towards: other).unit()
    }
    
    @available(*, deprecated, message: "This is backwards")
    func vector(to other: Self) -> Vector {
        if other == self { return .zero }
        assert(Vector.numberOfComponents == Self.numberOfComponents)
        
        let deltas = zip(components, other.components).map(-)
        return Vector(deltas)
    }
    
    func vector(towards other: Self) -> Vector {
        if other == self { return .zero }
        assert(Vector.numberOfComponents == Self.numberOfComponents)
        
        let deltas = zip(other.components, components).map(-)
        return Vector(deltas)
    }
    
    // a heading is strictly orthogonal
    func heading(to other: Self) -> Vector? {
        let componentDifferences = zip(components, other.components).map { $1 - $0 }
        // only one vector component can be non-zero
        // otherwise it's not orthogonal
        guard componentDifferences.count(where: { $0 != 0 }) == 1 else { return nil }
        return Vector(componentDifferences)
    }
    
    func apply(_ vector: Vector) -> Self {
        assert(Vector.numberOfComponents == Self.numberOfComponents)
        return Self(zip(components, vector.components).map(+))
    }
    
    func move(_ vector: Vector) -> Self { apply(vector) }
    
    func move(along vector: Vector, length: Int = 1) -> Self {
        let scaled = vector * length
        return apply(scaled)
    }
}
