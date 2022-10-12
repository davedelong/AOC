//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/14/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Droid {
    
    enum Space {
        case origin
        case empty
        case wall
        case droid
        case oxygen
    }
    
    let i: Intcode
    
    private var position: XY = .zero
    private var isBacktracking = false
    
    var path: Array<Heading>
    var grid = XYGrid<Space>()
    
    init(code: Intcode) {
        i = code
        path = [.north]
        grid[.zero] = .origin
    }
    
    private func backtrack(from proposedMove: Heading) {
        guard let moveToGetHere = path.last else {
            // we're back at zero
            // turn right and try again
            path.append(proposedMove.turnRight())
            return
        }
        
        let allowedMoves = [moveToGetHere, moveToGetHere.turnRight(), moveToGetHere.turnLeft()]
        if let idx = allowedMoves.firstIndex(of: proposedMove) {
            let idxOfNextMove = idx + 1
            if idxOfNextMove >= allowedMoves.endIndex {
                // no more valid moves
                path.removeLast()
                path.append(moveToGetHere.turnAround())
                isBacktracking = true
            } else {
                isBacktracking = false
                path.append(allowedMoves[idxOfNextMove])
            }
        } else {
            fatalError()
        }
    }
    
    private func nextMoveFromBacktrack(backtrack move: Heading) {
        let moveJustAttempted = move.turnAround()
        backtrack(from: moveJustAttempted)
    }
    
    func run() -> XY {
        while i.isHalted == false {
            i.runUntilBeforeNextIO()
            if i.isHalted { break }
            if i.needsIO() {
                switch path.last! {
                    case .north: i.io = 1
                    case .south: i.io = 2
                    case .west: i.io = 3
                    case .east: i.io = 4
                    default: fatalError()
                }
                i.step()
            } else {
                i.step()
                
                if i.io! == 0 {
                    // cannot move this way; hit a wall
                    let attempt = path.removeLast()
                    let wall = position.move(attempt)
                    grid[wall] = .wall
                    
                    backtrack(from: attempt)
                } else if i.io! == 1 {
                    // move
                    let thisMove = path.last!
                    let newPosition = position.move(thisMove)
                    
                    if grid[newPosition] == nil || isBacktracking == true {
                        position = newPosition
                        
                        if grid[position] == nil {
                            grid[position] = .empty
                        }
                        
                        if isBacktracking == false {
                            path.append(thisMove) // keep going
                        } else {
                            path.removeLast()
                            nextMoveFromBacktrack(backtrack: thisMove)
                        }
                        
                    } else {
                        // we've actually been here before; no need to return
                        path.removeLast()
                        // backtrack as if we hit a wall
                        backtrack(from: thisMove)
                    }
                } else if i.io! == 2 {
                    // moved and found the O2 system
                    let thisMove = path.last!
                    position = position.move(thisMove)
                    grid[position] = .oxygen
//                    return position
                }
            }
        }
        fatalError()
    }
    
    func draw() {
        let old = grid[position]
        grid[position] = .droid
        grid.draw { e in
            if e == .origin { return "🏠" }
            if e == .wall { return "⬛️" }
            if e == .droid { return "🤖" }
            if e == .oxygen { return "☁️" }
            if e == .empty { return "⬜️" }
            return "❓"
        }
        grid[position] = old
        print("======================================")
    }
    
}

class Day15: Day {
    
    func part1() async throws -> String {
        let i = Intcode(memory: input().integers)
        let d = Droid(code: i)
        let o2 = d.run()
        d.draw()
        let p1 = o2.manhattanDistance(to: .zero)
        return "\(p1)"
    }
    
    func part2() async throws -> String {
        return #function
    }
    
}
