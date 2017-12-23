//
//  Position.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

enum Heading {
    case north, south, west, east
    func turnLeft() -> Heading {
        switch self {
        case .north: return .west
        case .west: return .south
        case .south: return .east
        case .east: return .north
        }
    }
    func turnRight() -> Heading {
        switch self {
        case .north: return .east
        case .east: return .south
        case .south: return .west
        case .west: return .north
        }
    }
    func turnAround() -> Heading {
        switch self {
        case .north: return .south
        case .south: return .north
        case .east: return .west
        case .west: return .east
        }
    }
    func turn(clockwise: Int) -> Heading {
        var times = clockwise % 4
        while times < 0 { times += 4 }
        if times == 1 { return turnRight() }
        if times == 2 { return turnAround() }
        if times == 3 { return turnLeft() }
        return self
    }
}

struct Position: Hashable {
    static func ==(lhs: Position, rhs: Position) -> Bool { return lhs.x == rhs.x && lhs.y == rhs.y }
    var hashValue: Int { return x * 1000 + y}
    let x: Int; let y: Int
    
    func move(_ heading: Heading) -> Position {
        switch heading {
        case .north: return Position(x: x, y: y-1)
        case .south: return Position(x: x, y: y+1)
        case .east: return Position(x: x+1, y: y)
        case .west: return Position(x: x-1, y: y)
        }
    }
    
    func neighbors() -> Array<Position> {
        return [
            move(.north),
            move(.east),
            move(.south),
            move(.west)
        ]
    }
}

extension Array where Element: RandomAccessCollection, Element.Index == Int {
    subscript(key: Position) -> Element.Element? {
        if key.y < 0 { return nil }
        if key.y >= self.count { return nil }
        let row = self[key.y]
        
        if key.x < 0 { return nil }
        if key.x >= row.count { return nil }
        return row[key.x]
    }
}
