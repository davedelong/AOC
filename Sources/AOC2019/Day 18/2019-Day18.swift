//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/17/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

fileprivate extension XY {
    var position: vector_int2 { return vector_int2(x: Int32(x), y: Int32(y)) }
}

fileprivate func path<N>(from start: vector_int2, to end: vector_int2, in graph: GKGridGraph<N>) -> Array<N> {
    guard let s = graph.node(atGridPosition: start) else { return [] }
    guard let e = graph.node(atGridPosition: end) else { return [] }
    let nodes = graph.findPath(from: s, to: e)
    return nodes as! Array<N>
}

class Day18: Day {
    
    enum Maze: Equatable {
        case wall
        case open
        case key(Character)
        case door(Character)
        
        var isKey: Bool { return key != nil }
        var isDoor: Bool { return door != nil }
        
        var key: Character? {
            guard case .key(let k) = self else { return nil }
            return k
        }
        
        var door: Character? {
            guard case .door(let d) = self else { return nil }
            return d
        }
    }
    
    struct State {
        var remainingKeys = Dictionary<Character, XY>()
        var lockedDoors = Set<Character>()
        
        func isValid(_ path: Array<GridNode<Maze>>) -> Bool {
            guard path.isNotEmpty else { return false }
            
            for (index, step) in path.enumerated() {
                // if the door is locked, too bad; can't do this path
                if let d = step.value!.door, lockedDoors.contains(d) { return false }
                
                // this is a path that would run over a key to get here; we don't want that
                // we want to only consider paths that have open doors and no keys in the way
                if index > 0 && index < path.count - 1 {
                    if let k = step.value!.key, remainingKeys[k] != nil { return false }
                }
            }
            return true
        }
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    override func part1() -> String {
        var maze = XYGrid<Maze>()
        
        var lockedDoors = Dictionary<Character, XY>()
        var remainingKeys = Dictionary<Character, XY>()
        
        var collectedKeys = Set<Character>()
        var start: XY = .zero
        
        for (y, row) in input.lines.enumerated() {
            for (x, char) in row.characters.enumerated() {
                let m: Maze
                let xy = XY(x: x, y: y)
                switch char {
                    case "#": m = .wall
                    case ".": m = .open
                    case "@":
                        m = .open
                        start = xy
                    case _ where char.isLowercase:
                        m = .key(char)
                        remainingKeys[char] = xy
                    case _ where char.isUppercase:
                        m = .door(char)
                        lockedDoors[char] = xy
                    default: fatalError()
                }
                maze[xy] = m
                
            }
        }
        
        let g = maze.convertToGridGraph({ return $0 != .wall })
        
        var state = State()
        state.remainingKeys = remainingKeys
        state.lockedDoors = Set(lockedDoors.keys)
        
        let initialPaths = state.remainingKeys.values.map { xy -> Array<GridNode<Maze>> in
            return path(from: start.position, to: xy.position, in: g)
        }.filter { state.isValid($0) }
        
        let counts = initialPaths.compactMap { attempt(path: $0, state: state, in: g) }
        let steps = counts.min()!
        
        maze.draw(using: { m in
            guard let e = m else { return "?" }
            switch e {
                case .wall: return "⬛️"
                case .open: return "⬜️"
                case .key(let k): return "\(k)⃝"
                case .door(let d): return "\(d)⃞"
            }
        })
        
        return "\(steps)"
    }
    
    private func attempt(path thisPath: Array<GridNode<Maze>>, state: State, in graph: GKGridGraph<GridNode<Maze>>) -> Int? {
        guard state.remainingKeys.isNotEmpty else { return 0 }
        guard state.isValid(thisPath) else { return nil }
        
        let stepCount = thisPath.count - 1 // don't count the start position
        
        // the key is at the last step
        let key = thisPath.last!.value!.key!
        
        // propose the removal of this key
        var newState = state
        newState.remainingKeys[key] = nil
        newState.lockedDoors.remove(key.uppercased().first!)
        
        // if this was the last key, hooray!
        if newState.remainingKeys.isEmpty { return stepCount }
        
        let currentPosition = thisPath.last!.gridPosition
        let possibilities = newState.remainingKeys.values.map { xy -> Array<GridNode<Maze>> in
            return path(from: currentPosition, to: xy.position, in: graph)
        }
        
        let counts = possibilities.compactMap { p -> Int? in
            guard newState.isValid(p) else { return nil }
            return attempt(path: p, state: newState, in: graph)
        }
        
        guard counts.isNotEmpty else { return nil } // none of these paths could solve
        return stepCount + counts.min()!
    }
    
    override func part2() -> String {
        return #function
    }
    
}
