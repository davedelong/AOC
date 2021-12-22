//
//  Day20.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day20: Day {

    lazy var lookup: Array<Bool> = {
        input.lines[0].characters.map { $0 == "#" }
    }()
    
    lazy var loadedImage: XYGrid<Bool> = {
        let lines = input.lines.dropFirst(2)
        let bits = lines.map { l -> Array<Bit> in
            l.characters.map { $0 == "#" }
        }
        return XYGrid(data: bits)
    }()

    override func run() -> (String, String) {
        
        var p1 = 0
        
        var current = loadedImage
        var infiniteValue = false
        for l in 0 ..< 50 {
            if l == 2 { p1 = current.values.count(of: true) }
            current = enhance(current, infiniteValue: infiniteValue)
            infiniteValue.toggle()
        }
        
        let p2 = current.values.count(of: true)
        
        return (p1.description, p2.description)
    }
    
    func enhance(_ grid: XYGrid<Bit>, infiniteValue: Bit) -> XYGrid<Bit> {
        var xRange = grid.positions.range(of: \.x)
        var yRange = grid.positions.range(of: \.y)
        
        xRange = xRange.lowerBound-1 ... xRange.upperBound+1
        yRange = yRange.lowerBound-1 ... yRange.upperBound+1
        
        var copy = XYGrid<Bit>()
        
        for x in xRange {
            for y in yRange {
                let p = Position(x: x, y: y)
                let window = p.centeredWindow(length: 3)
                
                let bits = window.map { grid[$0] ?? infiniteValue }
                let index = Int(bits: bits)
                copy[p] = lookup[index]
            }
        }
        return copy
    }
}
