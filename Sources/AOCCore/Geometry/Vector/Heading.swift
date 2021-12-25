//
//  Heading.swift
//  AOC
//
//  Created by Dave DeLong on 12/24/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public typealias Heading = Vector2

public extension Vector2 {
    static var cardinalHeadings: Array<Self> { [up, down, left, right] }
    
    static var top: Vector2 { up }
    static var bottom: Vector2 { down }
    
    static var up: Vector2 { Vector2(x: 0, y: 1) }
    static var down: Vector2 { Vector2(x: 0, y: -1) }
    static var left: Vector2 { Vector2(x: -1, y: 0) }
    static var right: Vector2 { Vector2(x: 1, y: 0) }
    
    static var north: Vector2 { up }
    static var south: Vector2 { down }
    static var east: Vector2 { right }
    static var west: Vector2 { left }
    
    init?(character: Character) {
        switch character {
            case "U": self = .up
            case "D": self = .down
            case "L": self = .left
            case "R": self = .right
                
            case "^": self = .down  // assuming top-left origin, y *shrinks*
            case "v": self = .up    // assuming top-left origin, y *grows*
            case "<": self = .left
            case ">": self = .right
                
            case "N": self = .north
            case "S": self = .south
            case "E": self = .east
            case "W": self = .west
                
            default: return nil
        }
    }
    
    func turnLeft() -> Self {
        switch self {
            case .north: return .west
            case .west: return .south
            case .south: return .east
            case .east: return .north
            default: fatalError("Do some trig")
        }
    }
    
    func turnRight() -> Heading {
        switch self {
            case .north: return .east
            case .east: return .south
            case .south: return .west
            case .west: return .north
            default: fatalError("Do some trig")
        }
    }
    
    func turnAround() -> Heading { Vector2(x: -x, y: -y) }
    
    func turn(left: Bool, times: Int) -> Heading {
        if left {
            return turnLeft(times: times)
        } else {
            return turnRight(times: times)
        }
    }
    
    func turnLeft(times: Int) -> Heading {
        if times < 0 { return turnRight(times: -times) }
        let mod = times % 4
        if mod == 0 { return self }
        return (0 ..< mod).reduce(into: self) { h, _ in h = h.turnLeft() }
    }
    
    func turnRight(times: Int) -> Heading {
        if times < 0 { return turnLeft(times: -times) }
        let mod = times % 4
        if mod == 0 { return self }
        return (0 ..< mod).reduce(into: self) { h, _ in h = h.turnRight() }
    }
    
    func turn(clockwise: UInt) -> Heading {
        let times = clockwise % 4
        if times == 1 { return turnRight() }
        if times == 2 { return turnAround() }
        if times == 3 { return turnLeft() }
        return self
    }
    
    func turn(counterClockwise: UInt) -> Heading {
        let times = counterClockwise % 4
        if times == 1 { return turnLeft() }
        if times == 2 { return turnAround() }
        if times == 3 { return turnRight() }
        return self
    }
}
