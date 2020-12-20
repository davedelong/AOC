//
//  Heading.swift
//  AOC
//
//  Created by Dave DeLong on 12/24/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public enum Heading: CaseIterable {
    public static let up = Heading.north
    public static let top = Heading.north
    
    public static let down = Heading.south
    public static let bottom = Heading.south
    
    public static let left = Heading.west
    public static let right = Heading.east
    
    case north, south, west, east
    
    public init?(character: Character) {
        switch character {
            case "U": self = .up
            case "D": self = .down
            case "L": self = .left
            case "R": self = .right
                
            case "N": self = .north
            case "S": self = .south
            case "E": self = .east
            case "W": self = .west
                
            default: return nil
        }
    }
    
    public func turnLeft() -> Heading {
        switch self {
            case .north: return .west
            case .west: return .south
            case .south: return .east
            case .east: return .north
        }
    }
    public func turnRight() -> Heading {
        switch self {
            case .north: return .east
            case .east: return .south
            case .south: return .west
            case .west: return .north
        }
    }
    public func turnAround() -> Heading {
        switch self {
            case .north: return .south
            case .south: return .north
            case .east: return .west
            case .west: return .east
        }
    }
    public func turn(left: Bool, times: Int) -> Heading {
        if left {
            return turnLeft(times: times)
        } else {
            return turnRight(times: times)
        }
    }
    public func turnLeft(times: Int) -> Heading {
        if times < 0 { return turnRight(times: -times) }
        let mod = times % 4
        if mod == 0 { return self }
        return (0 ..< mod).reduce(into: self) { h, _ in h = h.turnLeft() }
    }
    public func turnRight(times: Int) -> Heading {
        if times < 0 { return turnLeft(times: -times) }
        let mod = times % 4
        if mod == 0 { return self }
        return (0 ..< mod).reduce(into: self) { h, _ in h = h.turnRight() }
    }
    public func turn(clockwise: UInt) -> Heading {
        let times = clockwise % 4
        if times == 1 { return turnRight() }
        if times == 2 { return turnAround() }
        if times == 3 { return turnLeft() }
        return self
    }
    
    public func turn(counterClockwise: UInt) -> Heading {
        let times = counterClockwise % 4
        if times == 1 { return turnLeft() }
        if times == 2 { return turnAround() }
        if times == 3 { return turnRight() }
        return self
    }
}
