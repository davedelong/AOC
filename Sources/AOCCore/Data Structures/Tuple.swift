//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/14/19.
//

import Foundation

public typealias Pair<T> = Tuple2<T, T>
public typealias Triple<T> = Tuple3<T, T, T>

public struct Tuple2<A, B> {
    public let first: A
    public let second: B
    public init(_ first: A, _ second: B) {
        self.first = first
        self.second = second
    }
}

public struct Tuple3<A, B, C> {
    public let first: A
    public let second: B
    public let third: C
    public init(_ first: A, _ second: B, _ third: C) {
        self.first = first
        self.second = second
        self.third = third
    }
}

public struct Tuple4<A, B, C, D> {
    public let first: A
    public let second: B
    public let third: C
    public let fourth: D
    public init(_ first: A, _ second: B, _ third: C, _ fourth: D) {
        self.first = first
        self.second = second
        self.third = third
        self.fourth = fourth
    }
}

extension Tuple2: Equatable where A: Equatable, B: Equatable {
    public static func ==(lhs: Tuple2, rhs: Tuple2) -> Bool {
        return lhs.first == rhs.first && lhs.second == rhs.second
    }
}

extension Tuple3: Equatable where A: Equatable, B: Equatable, C: Equatable {
    public static func ==(lhs: Tuple3, rhs: Tuple3) -> Bool {
        return lhs.first == rhs.first && lhs.second == rhs.second && lhs.third == rhs.third
    }
}

extension Tuple4: Equatable where A: Equatable, B: Equatable, C: Equatable, D: Equatable {
    public static func ==(lhs: Tuple4, rhs: Tuple4) -> Bool {
        return lhs.first == rhs.first && lhs.second == rhs.second && lhs.third == rhs.third && lhs.fourth == rhs.fourth
    }
}

extension Tuple2: Hashable where A: Hashable, B: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(first)
        hasher.combine(second)
    }
}

extension Tuple3: Hashable where A: Hashable, B: Hashable, C: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(first)
        hasher.combine(second)
        hasher.combine(third)
    }
}

extension Tuple4: Hashable where A: Hashable, B: Hashable, C: Hashable, D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(first)
        hasher.combine(second)
        hasher.combine(third)
        hasher.combine(fourth)
    }
}
