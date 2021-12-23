//
//  Day23.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day23: Day {
    
    enum Amphipod: Character, CaseIterable {
        case a = "A"
        case b = "B"
        case c = "C"
        case d = "D"
        
        var roomX: Int {
            switch self {
                case .a: return 2
                case .b: return 4
                case .c: return 6
                case .d: return 8
            }
        }
        
        var multiplier: Int {
            switch self {
                case .a: return 1
                case .b: return 10
                case .c: return 100
                case .d: return 1000
            }
        }
    }
    
    struct Burrow: Hashable {
        let roomCount: Int
        let allPositions: Array<Position>
        
        var positions = XYGrid<Amphipod>()
        var moves = CountedSet<Amphipod>()
        var cost: Int { Amphipod.allCases.sum { moves.count(for: $0) * $0.multiplier } }
        var isFinished: Bool { positions.allSatisfy { $0.y > 0 && $0.x == $1.roomX } }
        
        init(roomCount: Int) {
            self.roomCount = roomCount
            self.allPositions = [
                (0...10).map { Position(x: $0, y: 0) },
                (1...roomCount).map { Position(x: 2, y: $0) },
                (1...roomCount).map { Position(x: 4, y: $0) },
                (1...roomCount).map { Position(x: 6, y: $0) },
                (1...roomCount).map { Position(x: 8, y: $0) },
            ].flatten()
        }
        
        func stepsToMove(from s: Position, to e: Position) -> Int? {
            guard s != e else { return nil } // not a valid move
            guard s.y != e.y else { return nil } // can only move from room to hall and vice versa
            guard s.x != e.x else { return nil } // can only move from room to hall and vice versa
            
            guard let a = positions[s] else { return nil } // make sure there's something here to move
            guard positions[e] == nil else { return nil } // make sure the ending position is open
            
            if e.y == 0 { // if ending in the hall...
                // then nothing can stop in front of a room
                if e.x == 2 || e.x == 4 || e.x == 6 || e.x == 8 { return nil }
            }
            
            if s.y == 0 { // if starting in the hall...
                // then it can only move to the correct room
                guard e.y != 0 else { return nil }
                guard e.x == a.roomX else { return nil }
            }
            
            if s.x > 0 { // if starting inside a room ...
                // then it can only move to the hallway
                guard e.y == 0 else { return nil }
            }
            
            let steps = intermediateSteps(from: s, to: e)
            for i in steps {
                // we cannot move through an occupied position
                if positions[i] != nil { return nil }
            }
            
            // the number of steps is the manhattan distance between them
            return s.manhattanDistance(to: e)
        }
        
        private func intermediateSteps(from s: Position, to e: Position) -> Array<Position> {
            var intermediate = Array<Position>()
            let vector = e.vector(to: s)
            var c = s
            
            if s.y == 0 {
                // starting in the hall; move to over the room first, then down into the room
                while c.x != e.x {
                    c = c.offset(dx: vector.x.signum(), dy: 0)
                    intermediate.append(c)
                }
                while c.y != e.y {
                    c = c.offset(dx: 0, dy: vector.y.signum())
                    intermediate.append(c)
                }
            } else {
                // starting in the room; move up to the hall first, then across
                while c.y != e.y {
                    c = c.offset(dx: 0, dy: vector.y.signum())
                    intermediate.append(c)
                }
                while c.x != e.x {
                    c = c.offset(dx: vector.x.signum(), dy: 0)
                    intermediate.append(c)
                }
            }
            
            assert(intermediate.last == e)
            return intermediate.dropLast()
        }
    }
    
    /*
     Let's try the same logic as the other night:
     recursively solving stuff by iterating over possibilities and memoizing the result
     
     - build the starting burrow state
     - build a func that, given a state, returns the minimum cost to "complete" the state (or nil)
     - in that func, see if the state is finished. if it is, return the burrow cost
     - otherwise, compute all possible moves based on the state
     - generate a new state with the move applied, and recurse
     */
    
    let part1Burrow: Burrow = {
        var b = Burrow(roomCount: 2)
        b.positions[2, 1] = .c
        b.positions[2, 2] = .d
        b.positions[4, 1] = .a
        b.positions[4, 2] = .d
        b.positions[6, 1] = .b
        b.positions[6, 2] = .b
        b.positions[8, 1] = .c
        b.positions[8, 2] = .a
        return b
    }()
    
    let part2Burrow: Burrow = {
        var b = Burrow(roomCount: 4)
        b.positions[2, 1] = .c
        b.positions[2, 2] = .d
        b.positions[2, 3] = .d
        b.positions[2, 4] = .d
        
        b.positions[4, 1] = .a
        b.positions[4, 2] = .c
        b.positions[4, 3] = .b
        b.positions[4, 4] = .d
        
        b.positions[6, 1] = .b
        b.positions[6, 2] = .b
        b.positions[6, 3] = .a
        b.positions[6, 4] = .b
        
        b.positions[8, 1] = .c
        b.positions[8, 2] = .a
        b.positions[8, 3] = .c
        b.positions[8, 4] = .a
        return b
    }()
    
    override func part1() -> String {
        return minCost(for: part1Burrow).description
        // absolute minimum:
        //14 + 100 + 1100 + 17000 = 18214
        
        // attempts
        /*
         a = 4 + 3 +3 + 8
         b = 5 + 5
         c = 3 + 7 +5
         d = 8 + 9
         */
        // 18 + (10 * 10) + (15 * 100) + (17 * 1000) = 18618
        
        /*
         a = 8 + 9 + 3 + 9
         b = 5 + 5
         c = 2 + 5 + 6
         d = 8 + 9
         = 29 + (10 * 10) + (13 * 100) + (17 * 1000) = 18429
         */
        
        /*
         a = 3 + 4 + 6 + 9 + 9
         b = 7 + 7 + 5 + 5
         c = 7 + 4
         d = 8 + 9
         = 31 + (24 * 10) + (11 * 100) + (17 * 1000) = 18371
         */
        /*
         a = 10 + 4 + 3 + 3
         b = 5 + 5
         c = 2 + 5 + 6
         d = 8 + 9
         = 20 + 100 + 1300 + 17000 = 18420
         */
        /*
         a = 3 + 5 + 8
         b = 7 + 7 + 5 + 5
         c = 2 + 3 + 6
         d = 10 + 7
         = 16 + (24 * 10) + (11 * 100) + (17 * 1000) = 18356
         */
        /*
         a =4+6+9+9
         b =6+5+3+4
         c =5+6
         d =8+9
         = 28 + (18*10) + (11*100) + (17*1000) = 18308
         */
        /*
         a =5+3+4+8
         b =6+5+3+4
         c =5+6
         d =8+9
         =20 + (18 * 10) + 1100 + 17000 = 18300
         */
        return "18300"
    }
    
    override func part2() -> String {
        return minCost(for: part2Burrow).description
    }
    
    private func minCost(for burrow: Burrow) -> Int {
        var memo = Dictionary<Burrow, Int>()
        
        func computeCost(for burrow: Burrow) -> Int {
            if burrow.isFinished {
                return burrow.cost
            }
            if let c = memo[burrow] { return c }
            
            // it's not finished; compute all possible moves
            var cost = Int.max
            // if we recurse to this state again, assume it's unsolveable
            memo[burrow] = cost
            for start in burrow.allPositions {
                for end in burrow.allPositions {
                    if let steps = burrow.stepsToMove(from: start, to: end) {
                        var copy = burrow
                        let pod = copy.positions[start]!
                        copy.positions[end] = pod
                        copy.positions[start] = nil
                        copy.moves.insert(item: pod, times: steps)
                        let copyCost = computeCost(for: copy)
                        cost = min(cost, copyCost)
                    } else {
                        // cannot move between these two positions
                    }
                }
            }
            memo[burrow] = cost
            return cost
        }
        
        let c = computeCost(for: burrow)
        return c
    }
}
