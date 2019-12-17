//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/14/19.
//

import Foundation

public struct XYGrid<T> {
    
    private var grid = Dictionary<XY, T>()
    
    public init() { }
    
    public subscript(key: XY) -> T? {
        get { return grid[key] }
        set { grid[key] = newValue }
    }
    
    public func draw(using renderer: (T?) -> String) {
        
        let xRange = grid.keys.map { $0.x }.range()
        let yRange = grid.keys.map { $0.y }.range()
        
        for y in yRange {
            for x in xRange {
                let xy = XY(x: x, y: y)
                let s = renderer(grid[xy])
                print(s, terminator: "")
            }
            print("")
        }
        
    }
    
    
    
}
