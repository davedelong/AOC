//
//  Day20.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

// this needs . instead of spaces
// because xcode very "helpfully" would trim the whitespace at the end of the lines
// which makes all the lines no longer be the same size
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
                default: fatalError()
            }
        }
        
        func rotate() { matrix = matrix.rotate(1) }
        func mirror() { matrix = matrix.flip() }
        
        func make(edge: Array<Bool>, beOnSide targetSide: Heading, canTransform: Bool) {
            guard edges.contains(edge) else { fatalError() }
            if self.edge(for: targetSide) == edge { return }
            
            if canTransform == true {
                rotate()
                if self.edge(for: targetSide) == edge { return }
                rotate()
                if self.edge(for: targetSide) == edge { return }
                rotate()
                if self.edge(for: targetSide) == edge { return }
                
                mirror()
                if self.edge(for: targetSide) == edge { return }
                    
                rotate()
                if self.edge(for: targetSide) == edge { return }
                rotate()
                if self.edge(for: targetSide) == edge { return }
                rotate()
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
        
        let topLeft = corners[0]
        remainingTiles.remove(topLeft)
        
        var cornerEdges = Set(remainingTiles.compactMap { tile -> Array<Bool>? in
            let matches = topLeft.coreEdges.intersection(tile.edges)
            return matches.first
        })
        cornerEdges.formUnion(cornerEdges.map { $0.reversed() })
        
        // rotate the corner tile until the common edges are facing down and right
        while Set([topLeft.edge(for: .right), topLeft.edge(for: .bottom)]).isSubset(of: cornerEdges) == false {
            topLeft.rotate()
        }
        
        grid[0, 0] = topLeft
        
        var row = 0
        var col = 1
        var keepBuildingRow = true
        while remainingTiles.isNotEmpty {
            while keepBuildingRow {
                let p = Point2(row: row, column: col)
                let pointsAround = p.surroundingPositions(includingDiagonals: false).filter { grid[$0] != nil }
                // when building a grid, a new tile can only connect to one or two existing tiles
                guard pointsAround.count <= 2 else { fatalError() }
                
                var possibleMatches = remainingTiles
                var canTransform = true
                
                // for each already-placed tile...
                for around in pointsAround {
                    let theirSide = around.heading(to: p)!
                    let their = grid[around]!
                    // get their edge we'd need to connect to
                    let theirEdge = their.edge(for: theirSide)
                    // find the remaining tiles that can connect to it
                    possibleMatches = possibleMatches.filter { $0.edges.contains(theirEdge) }
                    // make sure they're oriented correctly
                    possibleMatches.forEach { tile in
                        tile.make(edge: theirEdge, beOnSide: theirSide.turnAround(), canTransform: canTransform)
                    }
                    if possibleMatches.isEmpty { break }
                    canTransform.toggle()
                }
                
                // if we got a tile, put it in the grid
                if let tile = possibleMatches.first {
                    grid[p] = possibleMatches.first
                    remainingTiles.remove(tile)
                }
                
                col += 1
                // if there wasn't a matching tile, we reached the end of the row
                keepBuildingRow = possibleMatches.isNotEmpty
            }
            // move to the next row
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
        grid.grid.values.forEach { $0.matrix.inset(by: [.top: 1, .bottom: 1, .left: 1, .right: 1]) }
        
        let nested = grid.convertToNestedArray()
        var new = Array<Array<Bool>>()
        for row in nested {
            let subRowCount = row[0]!.matrix.data.count
            
            for rowIdx in 0 ..< subRowCount {
                var newRow = Array<Bool>()
                for tile in row {
                    newRow.append(contentsOf: tile!.matrix.row(rowIdx))
                }
                new.append(newRow)
            }
        }
        var combined = Matrix(new)
//        combined = combined.rotate(1)
//        combined.mirror()
//
//        let debug = combined.map({ _, _, b -> String in return b ? "#" : "." })
//        print(debug)
        
        // try all the orientations of the image to see which one has the monsters
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
        let part2 = hashSquares - (seaMonstersFound * seaMonsterTileCount)
        
        return ("\(corners.product(of: \.id))", "\(part2)")
    }
    
    lazy var seaMonster: Array<Array<Bool?>> = {
        return rawSeaMonster.split(on: "\n").map { line -> Array<Bool?> in
            return line.map { $0 == "#" ? true : nil }
        }
    }()
    
    lazy var seaMonsterTileCount: Int = {
        return seaMonster.sum(of: { line -> Int in
            line.count(where: { $0 == true })
        })
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
