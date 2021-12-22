//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/14/19.
//

import Foundation
import GameplayKit

public typealias XYGrid<T> = Space<Point2, T>

extension Space where P == Point2 {
    
    public init(data: Array<Array<T>>) {
        for y in 0 ..< data.count {
            let row = data[y]
            for x in 0 ..< row.count {
                self[x, y] = row[x]
            }
        }
    }
    
    public subscript(x: Int, _ y: Int) -> T? {
        get { self[Point2(x: x, y: y)] }
        set { self[Point2(x: x, y: y)] = newValue }
    }
    
    public var positions: Dictionary<P, T>.Keys { return grid.keys }
    public var values: Dictionary<P, T>.Values { return grid.values }
    
    public func draw(using renderer: (T?) -> String) {
        print(render(using: renderer))
    }
    
    public func render(using renderer: (T?) -> String) -> String {
        var final = String()
        
        let xRange = grid.keys.map(\.x).range()
        let yRange = grid.keys.map(\.y).range()
        
        for y in yRange {
            for x in xRange {
                let p = P(x: x, y: y)
                let s = renderer(grid[p])
                final.append(s)
            }
            final.append("\n")
        }
        
        return final
    }
    
    public func convertToGridGraph(_ canEnterPosition: (T) -> Bool) -> GKGridGraph<GridNode<T>> {
        
        let xRange = grid.keys.map { $0.x }.range()
        let yRange = grid.keys.map { $0.y }.range()
        
        let g: GKGridGraph<GridNode<T>> = GKGridGraph(fromGridStartingAt: vector_int2(x: Int32(xRange.lowerBound), y: Int32(yRange.lowerBound)),
                                                      width: Int32(xRange.count),
                                                      height: Int32(yRange.count),
                                                      diagonalsAllowed: false,
                                                      nodeClass: GridNode<T>.self)
        
        for x in xRange {
            for y in yRange {
                let node = g.node(atGridPosition: vector_int2(x: Int32(x), y: Int32(y)))!
                node.value = self[XY(x: x, y: y)]!
                
                if canEnterPosition(node.value!) == false {
                    let connections = node.connectedNodes
                    node.removeConnections(to: connections, bidirectional: true)
                }
            }
        }
        
        return g
    }
    
    public func convertToNestedArray() -> Array<Array<T?>> {
        var final = Array<Array<T?>>()
        
        let xRange = grid.keys.map { $0.x }.range()
        let yRange = grid.keys.map { $0.y }.range()
        
        for y in yRange {
            var row = Array<T?>()
            for x in xRange {
                row.append(self[Point2(x: x, y: y)])
            }
            final.append(row)
        }
        
        return final
    }
    
    public func forEach(_ element: (Position, T) -> Void) {
        grid.forEach(element)
    }
}

extension Space where P == Point2, T == Bool {
    
    public func render() -> String {
        return self.render(using: { $0 == true ? "⬛️" : "⬜️" })
    }
    
    public func draw() {
        print(render())
    }
    
}

public class GridNode<T>: GKGridGraphNode {
    
    public var value: T?
    
    public override var description: String {
        return "Node<\(T.self)>(\(String(describing: value)))"
    }
    
    public override init(gridPosition: vector_int2) {
        super.init(gridPosition: gridPosition)
    }
    
    public init(_ value: T, position: vector_int2) {
        self.value = value
        super.init(gridPosition: position)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
