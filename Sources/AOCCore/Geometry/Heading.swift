//
//  Heading.swift
//  AOC
//
//  Created by Dave DeLong on 12/24/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public enum Heading: CaseIterable {
    case north, south, west, east
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