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
    
    struct Path {
        let nodes: Array<GridNode<Maze>>
        var key: Character { nodes.last!.value!.key! }
        let doors: Set<Character>
        var stepCount: Int { nodes.count - 1 }
        
        init(nodes: Array<GridNode<Maze>>) {
            self.nodes = nodes
            self.doors = Set(nodes.compactMap { $0.value?.door })
        }
    }
    
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
        var order = ""
        var stepCount = 0
        var paths = Dictionary<Pair<Character>, Path>()
        var remainingKeys = Dictionary<Character, XY>()
        var lockedDoors = Set<Character>()
        
        func isValid(_ path: Path) -> Bool {
            guard path.nodes.isNotEmpty else { return false }
            if path.doors.isEmpty { return true }
            if lockedDoors.intersects(path.doors) { return false }
            
            for node in path.nodes.dropLast() {
                if let k = node.value?.key, remainingKeys[k] != nil { return false }
            }
            
            return true
        }
        
        func path(from: Character, to: Character) -> Path? {
            let pair = Pair(from, to)
            if let p = paths[pair] { return p }
            let reversed = Pair(to, from)
            return paths[reversed]
        }
        
        func validPath(from: Character, to: Character) -> Path? {
            guard let p = path(from: from, to: to) else { return nil }
            guard isValid(p) else { return nil }
            return p
        }
    }
    
    var memoizedPathCounts = Dictionary<Tuple2<Character, Set<Character>>, Int>()
    
    override func part1() -> String {
        var maze = XYGrid<Maze>()
        
        var lockedDoors = Dictionary<Character, XY>()
        var remainingKeys = Dictionary<Character, XY>()
        
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
        
        for (key, startXY) in state.remainingKeys {
            for (otherKey, endXY) in state.remainingKeys {
                if key == otherKey { continue }
                let p = path(from: startXY.position, to: endXY.position, in: g)
                state.paths[Pair(key, otherKey)] = Path(nodes: p)
            }
        }
        
        let initialPaths = state.remainingKeys.values.map { xy -> Path in
            return Path(nodes: path(from: start.position, to: xy.position, in: g))
        }.filter { state.isValid($0) }
        
        print("ORDER: ")
        let keys = initialPaths.map { $0.key }
        print("\(keys)")
        
        let counts = initialPaths.compactMap { attempt(path: $0, state: state) }
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
    
    private func attempt(path thisPath: Path, state: State) -> Int? {
        guard state.remainingKeys.isNotEmpty else { return 0 }
        guard state.isValid(thisPath) else { return nil }
        
        let cacheKey = Tuple2(thisPath.key, Set(state.remainingKeys.keys))
        let stepCount = thisPath.stepCount
        
        if let count = memoizedPathCounts[cacheKey] {
            return stepCount + count
        }
        
        let key = thisPath.key
        
        // propose the removal of this key
        var newState = state
        newState.stepCount += thisPath.stepCount
        newState.order.append(key)
        newState.remainingKeys[key] = nil
        newState.lockedDoors.remove(key.uppercased().first!)
        
        // if this was the last key, hooray!
        if newState.remainingKeys.isEmpty {
            print("SOLUTION: \(state.order) (\(newState.stepCount))")
            return stepCount
        }
        
        let possibilities = newState.remainingKeys.keys.compactMap { k -> Path? in
            return newState.validPath(from: key, to: k)
        }
        
        guard possibilities.isNotEmpty else { return nil }
        
        let counts = possibilities.compactMap { p -> Int? in
            return attempt(path: p, state: newState)
        }
        
        guard counts.isNotEmpty else { return nil } // none of these paths could solve
        
        let c = counts.min()!
        memoizedPathCounts[cacheKey] = c
        
        return stepCount + c
    }
    
    override func part2() -> String {
        return #function
    }
    
}
