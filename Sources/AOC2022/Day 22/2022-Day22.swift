//
//  Day22.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day22: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    enum Space {
        case open
        case wall
        case void
    }
    
    enum Instruction {
        case move(Int)
        case turn(Heading)
    }
    
    enum Heading {
        case up
        case down
        case left
        case right
        
        init?(character: Character) {
            switch character {
                case "L": self = .left
                case "R": self = .right
                default: return nil
            }
        }
        
        func opposing() -> Self {
            switch self {
                case .up: return .down
                case .down: return .up
                case .left: return .right
                case .right: return .left
            }
        }
        
        func turnLeft() -> Self {
            switch self {
                case .up: return .left
                case .left: return .down
                case .down: return .right
                case .right: return .right
            }
        }
        
        func turnRight() -> Self {
            switch self {
                case .up: return .right
                case .right: return .down
                case .down: return .left
                case .left: return .up
            }
        }
    }
    
    func parseInput() -> (Matrix<Space>, Point2, Array<Instruction>) {
        let blankOffset = input().lines[0].raw.prefix(while: \.isWhitespace).count
        
        let sections = input().lines.split(on: \.isEmpty)
        let definition = sections[0]
        let rawData = definition.map { line in
            line.raw.map { char -> Space in
                if char == "#" { return .wall }
                if char == "." { return .open }
                return .void
            }
        }
        
        let length = rawData.max(of: \.count)
        let paddedData = rawData.map { $0.padded(toLength: length, with: .void) }
        
        let grid = Matrix(paddedData)
        
        let turns = sections[1].first!.raw
        var scanner = Scanner(data: turns)
        var instructions = Array<Instruction>()
        
        while scanner.isAtEnd == false {
            if let i = scanner.tryScanInt() {
                instructions.append(.move(i))
            } else if let char = scanner.scanElement(), let heading = Heading(character: char) {
                instructions.append(.turn(heading))
            } else {
                fatalError()
            }
        }
        
        return (grid, Point2(row: 0, column: blankOffset), instructions)
    }

    func part1() async throws -> Part1 {
        let (grid, start, moves) = parseInput()
        
        var position = start
        var direction = Heading.right
        
        func wrap(position: Point2) -> Point2 {
            let reverse = direction.opposing()
            var next = position.move(reverse)
            while grid.has(next) && grid[next] != .void {
                next = next.move(reverse)
            }
            return next.move(direction)
        }
        
        for move in moves {
            switch move {
                case .move(let i):
                    for _ in 0 ..< i {
                        var proposed = position.move(direction)
                        // first make sure it's on the grid, else wrap around
                        if grid.has(proposed) == false || grid[proposed] == .void {
                            proposed = wrap(position: proposed)
                        }
                        
                        // next, make sure it's not blocked
                        if grid[proposed] != .open {
                            break
                        }
                        
                        position = proposed
                    }
                case .turn(let h) where h == .right:
                    direction = direction.turnRight()
                case .turn(let h) where h == .left:
                    direction = direction.turnLeft()
                default: fatalError()
            }
        }
        
        let rowFinal = (position.row + 1) * 1000
        let colFinal = (position.col + 1) * 4
        let facingFinal: Int = {
            switch direction {
                case .right: return 0
                case .down: return 1
                case .left: return 2
                case .up: return 3
            }
        }()
        
        return rowFinal + colFinal + facingFinal
    }

    func part2() async throws -> Part2 {
        let cubeDim = 50
        let (grid, start, moves) = parseInput()
        
        var position = start
        var direction = Heading.right
        
        func cubeWrap(position: Point2) -> (Point2, Heading) {
            // first, determine which face we're one
            let x = position.col / cubeDim
            let y = position.row / cubeDim
            
            let face: Int
            switch (x, y) {
                case (2, 0): face = 1
                case (1, 0): face = 2
                case (1, 1): face = 3
                case (1, 2): face = 4
                case (0, 2): face = 5
                case (0, 3): face = 6
                default: fatalError()
            }
            
            let colRem = position.col % cubeDim
            let rowRem = position.row % cubeDim
            
            // next, based on our heading, we move to certain faces
            switch (face, direction) {
                case (1, .up):
                    // connects to the bottom of face 6
                    return (Point2(row: (cubeDim * 4) - 1, column: colRem), .up)
                    
                case (1, .down):
                    // connects to the right of face 3, with the row/col transposed
                    return (Point2(row: cubeDim + colRem, column: (cubeDim * 2) - 1), .right)
                    
                case (1, .right):
                    // connects to the right of face 4, upside down
                    return (Point2(row: (cubeDim * 2) + (cubeDim - rowRem), column: (cubeDim * 2) - 1), .right)
                    
                case (2, .up):
                    // connects to the left of face 6
                    return (Point2(row: (cubeDim * 3) + colRem, column: 0), .left)
                    
                case (2, .left):
                    // connects to the left of face 5, upside down
                    return (Point2(row: (cubeDim * 2) + (cubeDim - rowRem), column: 0), .left)
                    
                case (3, .left):
                    // connects to the top of face 5
                    return (Point2(row: (2 * cubeDim), column: rowRem), .down)
                    
                case (3, .right):
                    // connects to the bottom of face 1
                    return (Point2(row: cubeDim - 1, column: (2 * cubeDim) + rowRem), .up)
                    
                case (4, .right):
                    // connects to the right of face 1, upside down
                    return (Point2(row: cubeDim - rowRem, column: (cubeDim * 3) - 1), .right)
                    
                case (4, .down):
                    // connects to the right of face 6
                    return (Point2(row: (cubeDim * 3) + colRem, column: cubeDim - 1), .right)
                    
                case (5, .up):
                    // connects to the left of face 3
                    return (Point2(row: cubeDim + colRem, column: cubeDim), .left)
                    
                case (5, .left):
                    // connects to the left of face 2, upside down
                    return (Point2(row: cubeDim - rowRem, column: cubeDim), .left)
                    
                case (6, .left):
                    // connects to the top of face 2
                    return (Point2(row: 0, column: cubeDim + rowRem), .down)
                    
                case (6, .down):
                    // connects to the top of face 1
                    return (Point2(row: 0, column: (cubeDim * 2) + colRem), .down)
                    
                case (6, .right):
                    // connects to the bottom of face 4
                    return (Point2(row: (cubeDim * 3) - 1, column: cubeDim + rowRem), .up)
                    
                default: fatalError()
            }
        }
        
        for move in moves {
            switch move {
                case .move(let i):
                    var newHeading = direction
                    for _ in 0 ..< i {
                        var proposed = position.move(newHeading)
                        // first make sure it's on the grid, else wrap around
                        if grid.has(proposed) == false || grid[proposed] == .void {
                            (proposed, newHeading) = cubeWrap(position: position)
                        }
                        
                        // next, make sure it's not blocked
                        if grid[proposed] != .open {
                            break
                        }
                        
                        position = proposed
                        direction = newHeading
                    }
                case .turn(let h) where h == .right:
                    direction = direction.turnLeft()
                case .turn(let h) where h == .left:
                    direction = direction.turnRight()
                default: fatalError()
            }
        }
        
        let rowFinal = (position.row + 1) * 1000
        let colFinal = (position.col + 1) * 4
        let facingFinal: Int = {
            switch direction {
                case .right: return 0
                case .down: return 1
                case .left: return 2
                case .up: return 3
            }
        }()
        
        return rowFinal + colFinal + facingFinal
    }

    func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

}

extension Point2 {
    
    func move(_ heading: Day22.Heading) -> Point2 {
        switch heading {
            case .up: return Point2(row: row - 1, column: col)
            case .down: return Point2(row: row + 1, column: col)
            case .left: return Point2(row: row, column: col - 1)
            case .right: return Point2(row: row, column: col + 1)
        }
    }
    
}
