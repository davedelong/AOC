//
//  Day20.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

let rawSeaMonster = """
..................#.
#....##....##....###
.#..#..#..#..#..#...
"""


class Day20: Day {
    
    class Tile: Equatable, Hashable {
        static func == (lhs: Day20.Tile, rhs: Day20.Tile) -> Bool {
            lhs.id == rhs.id
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        enum Action {
            case rotateCW
            case mirror
        }
        
        let id: Int
        private(set) var matrix: Matrix<Bool>
        
        let coreEdges: Set<[Bool]>
        let edges: Set<[Bool]>
        
        internal init(id: Int, matrix: Matrix<Bool>) {
            self.id = id
            self.matrix = matrix
            self.coreEdges = [
                matrix.data[0],
                matrix.data.last!,
                matrix.data.compactMap(\.first),
                matrix.data.compactMap(\.last),
            ]
            self.edges = [
                matrix.data[0],
                matrix.data.last!,
                matrix.data.compactMap(\.first),
                matrix.data.compactMap(\.last),
                
                matrix.data[0].reversed(),
                matrix.data.last!.reversed(),
                matrix.data.compactMap(\.first).reversed(),
                matrix.data.compactMap(\.last).reversed(),
            ]
        }
        
        func numberOfEdgesInCommon(with other: Tile) -> Int {
            guard other.id != self.id else { fatalError() }
            return coreEdges.intersection(other.edges).count
        }
        
        func edge(for side: Heading) -> Array<Bool> {
            switch side {
                case .north: return matrix.data[0]
                case .east: return matrix.data.compactMap(\.last)
                case .south: return matrix.data.last!
                case .west: return matrix.data.compactMap(\.first)
            }
        }
        
        func perform(action: Action) {
            if action == .rotateCW {
                matrix = matrix.rotate(1)
            } else {
                matrix = matrix.flip()
            }
        }
        
        func make(edge: Array<Bool>, beOnSide targetSide: Heading, canRotate: Bool) {
            guard edges.contains(edge) else { fatalError() }
            if self.edge(for: targetSide) == edge { return }
            
            if canRotate == true {
                perform(action: .rotateCW)
                if self.edge(for: targetSide) == edge { return }
                perform(action: .rotateCW)
                if self.edge(for: targetSide) == edge { return }
                perform(action: .rotateCW)
                if self.edge(for: targetSide) == edge { return }
            }
            perform(action: .mirror)
            if self.edge(for: targetSide) == edge { return }
            
            if canRotate == true {
                perform(action: .rotateCW)
                if self.edge(for: targetSide) == edge { return }
                perform(action: .rotateCW)
                if self.edge(for: targetSide) == edge { return }
                perform(action: .rotateCW)
                if self.edge(for: targetSide) == edge { return }
            }
            fatalError()
        }
    }
    
    lazy var tiles: Array<Tile> = {
        input.raw.split(on: "\n\n").map { chunk -> Tile in
            let lines = chunk.split(on: "\n")
            let id = Array(integersIn: lines[0])[0]
            
            let pieces = lines.dropFirst()
            let initial = pieces.map { $0.map { $0 == "#" } }
            return Tile(id: id, matrix: Matrix(initial))
        }
    }()
    
    private func findCorners() -> Array<Tile> {
        // the corners are the tiles where only two tiles can match
        var corners = Array<Tile>()
        
        for tile in tiles {
            var matches = Dictionary<Int, Int>()
            for otherTile in tiles {
                if tile.id == otherTile.id { continue }
                let commonEdgeCount = tile.numberOfEdgesInCommon(with: otherTile)
                if commonEdgeCount > 0 { matches[otherTile.id] = commonEdgeCount }
            }
            
            if matches.count == 2 { corners.append(tile) }
        }
        return corners
    }
    
    func buildGrid() -> XYGrid<Tile> {
        var remainingTiles = Set(tiles)
        let corners = self.findCorners()
        
        var grid = XYGrid<Tile>()
        var row = 0
        var col = 1
        var keepBuildingRow = true
        
        let topLeft = corners[0]
        remainingTiles.remove(topLeft)
        
        var matches = Set(remainingTiles.compactMap { tile -> Array<Bool>? in
            let matches = topLeft.coreEdges.intersection(tile.edges)
            return matches.first
        })
        matches.formUnion(matches.map { $0.reversed() })
        
        while Set([topLeft.edge(for: .right), topLeft.edge(for: .bottom)]).isSubset(of: matches) == false {
            topLeft.perform(action: .rotateCW)
        }
        
        grid[0, 0] = topLeft
        
        while remainingTiles.isNotEmpty {
            while keepBuildingRow {
                let p = Point2(row: row, column: col)
                print("Attempting to build \(p)")
                let pointsAround = p.surroundingPositions(includingDiagonals: false).filter { grid[$0] != nil }
                guard pointsAround.count <= 2 else { fatalError() }
                
                var possibleMatches = remainingTiles
                var canRotate = true
                for around in pointsAround {
                    let theirSide = around.heading(to: p)!
                    let their = grid[around]!
                    let theirEdge = their.edge(for: theirSide)
                    possibleMatches = possibleMatches.filter { $0.edges.contains(theirEdge) }
                    possibleMatches.forEach { tile in
                        tile.make(edge: theirEdge, beOnSide: theirSide.turnAround(), canRotate: canRotate)
                    }
                    if possibleMatches.isEmpty { break }
                    canRotate.toggle()
                }
                
                if let tile = possibleMatches.first {
                    grid[p] = possibleMatches.first
                    remainingTiles.remove(tile)
                } else {
                    print("Nothing connects to \(p)")
                }
                
                col += 1
                keepBuildingRow = possibleMatches.isNotEmpty
            }
            row += 1
            col = 0
            keepBuildingRow = true
        }
        return grid
    }

    override func run() -> (String, String) {
        
        let corners = self.findCorners()
        
        let grid = self.buildGrid()
        // inset to remove the borders
//        grid.grid.values.forEach { $0.matrix.inset(by: [.top: 1, .bottom: 1, .left: 1, .right: 1]) }
        
        let nested = grid.convertToNestedArray()
        var new = Array<Array<Bool>>()
        for row in nested {
            let subRowCount = row[0]!.matrix.data.count
            
            for rowIdx in 0 ..< subRowCount {
                var newRow = Array<Bool>()
                for tile in row {
                    newRow.append(contentsOf: tile!.matrix.data[rowIdx])
                }
                new.append(newRow)
            }
        }
        var combined = Matrix(new)
        
        let debug = combined.map({ _, _, b -> String in return b ? "X" : " " })
        print(debug)
        
        var seaMonstersFound = countSeaMonsters(in: combined)
        if seaMonstersFound == 0 {
            combined = combined.rotate(1)
            seaMonstersFound = countSeaMonsters(in: combined)
        }
        if seaMonstersFound == 0 {
            combined = combined.rotate(1)
            seaMonstersFound = countSeaMonsters(in: combined)
        }
        if seaMonstersFound == 0 {
            combined = combined.rotate(1)
            seaMonstersFound = countSeaMonsters(in: combined)
        }
        if seaMonstersFound == 0 {
            combined = combined.flip()
            seaMonstersFound = countSeaMonsters(in: combined)
        }
        if seaMonstersFound == 0 {
            combined = combined.rotate(1)
            seaMonstersFound = countSeaMonsters(in: combined)
        }
        if seaMonstersFound == 0 {
            combined = combined.rotate(1)
            seaMonstersFound = countSeaMonsters(in: combined)
        }
        if seaMonstersFound == 0 {
            combined = combined.rotate(1)
            seaMonstersFound = countSeaMonsters(in: combined)
        }
        
        let hashSquares = combined.count(where: { $0 })
        let part2 = hashSquares - (seaMonstersFound * 13)
        
        return ("\(corners.product(of: \.id))", "\(part2)")
    }
    
    lazy var seaMonster: Array<Array<Bool?>> = {
        return rawSeaMonster.split(on: "\n").map { line -> Array<Bool?> in
            return line.map { $0 == "#" ? true : nil }
        }
    }()
    
    private func countSeaMonsters(in matrix: Matrix<Bool>) -> Int {
        let size = Size(width: seaMonster[0].count, height: seaMonster.count)
        
        var seaMonsterCount = 0
        matrix.withSlidingWindow(of: size, perform: { window in
            var found = true
            outer: for y in 0 ..< size.height {
                for x in 0 ..< size.width {
                    if let match = seaMonster[y][x] {
                        if window[y][x] != match {
                            found = false
                            break outer
                        }
                    }
                }
            }
            seaMonsterCount += (found ? 1 : 0)
        })
        return seaMonsterCount
    }

}
