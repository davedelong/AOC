//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/21/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2017 {

public class Day22: Day {

    enum State {
        case clean, weakened, infected, flagged
        
        func flip() -> State {
            return self == .clean ? .infected : .clean
        }
        
        func rotate() -> State {
            switch self {
                case .clean: return .weakened
                case .weakened: return .infected
                case .infected: return .flagged
                case .flagged: return .clean
            }
        }
    }

    var grid = Dictionary<Position, State>()
    
    public init() { super.init(inputFile: #file) }
    
    func resetGrid() {
        grid.removeAll()
        let rawGrid = input.lines.raw
        
        for (y, line) in rawGrid.enumerated() {
            for (x, char) in line.enumerated() {
                let state = char == "#" ? State.infected : State.clean
                grid[Position(x: x, y: y)] = state
            }
        }
    }
    
    func burst(position: Position, heading: Heading, infector: (State) -> State, mover: (State, Heading) -> Heading) -> (Position, Heading, Bool) {
        let state = grid[position] ?? .clean
        let newState = infector(state)
        grid[position] = newState
        
        let newHeading = mover(state, heading)
        let newPosition = position.move(newHeading)
        let causedInfection = newState == .infected
        
        return (newPosition, newHeading, causedInfection)
    }
    
    func countInfections(iterations: Int, infector: (State) -> State, mover: (State, Heading) -> Heading) -> Int {
        resetGrid()
        
        var current = Position(x: 12, y: 12)
        var heading = Heading.north
        var infections = 0
        
        for _ in 0 ..< iterations {
            let (p, h, i) = burst(position: current, heading: heading, infector: infector, mover: mover)
            current = p
            heading = h
            if i { infections += 1 }
        }
        return infections
    }
    
    override public func part1() -> String {
        let inf = countInfections(iterations: 10_000, infector: { $0.flip() }, mover: {
            $0 == .infected ? $1.turnRight() : $1.turnLeft()
        })
        return "\(inf)"
    }

    override public func part2() -> String {
        let inf = countInfections(iterations: 10_000_000, infector: { $0.rotate() }, mover: {
            switch $0 {
                case .clean: return $1.turnLeft()
                case .weakened: return $1
                case .infected: return $1.turnRight()
                case .flagged: return $1.turnAround()
            }
        })
        return "\(inf)"
    }
}

}
