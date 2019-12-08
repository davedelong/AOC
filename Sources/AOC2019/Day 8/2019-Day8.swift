//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/7/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

class Day8: Day {
    
    override func run() -> (String, String) {
        let size = CGSize(width: 25, height: 6)
        let numberOfPixels = 25 * 6
        let rawData = input.characters.compactMap { Int("\($0)") }
        let layers = rawData.chunks(of: numberOfPixels).map { Array($0) }
        
        let layersWithZeroCounts = layers.map { pixels -> (Array<Int>, Int) in
            return (pixels, pixels.count(where: { $0 == 0 }))
        }
        
        let layerWithLeastZeros = layersWithZeroCounts.min(by: { $0.1 < $1.1 })!
        let layerPixels = layerWithLeastZeros.0
        
        let numberOfOnes = layerPixels.count(where: { $0 == 1 })
        let numberOfTwos = layerPixels.count(where: { $0 == 2 })
        
        let p1 = "\(numberOfOnes * numberOfTwos)"
        
        
        var resolvedPixels = Array<Int>(repeating: 0, count: numberOfPixels)
        
        for p in 0 ..< numberOfPixels {
            var pixelValue = 0
            for layer in layers {
                if layer[p] == 2 { continue }
                pixelValue = layer[p]
                break
            }
            resolvedPixels[p] = pixelValue
        }
        
        let rows = resolvedPixels.chunks(of: 25)
        for row in rows {
            let t = row.map { "\($0 == 0 ? " " : "#")" }.joined()
            print(t)
        }
        
        
        return (p1, "CFCUG")
    }
    
}
