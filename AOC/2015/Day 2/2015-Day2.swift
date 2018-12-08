//
//  Day2.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

extension Year2015 {

    public class Day2: Day {
        
        struct Box {
            let length: Int
            let width: Int
            let height: Int
            
            var surfaceArea: Int {
                let sideA = length * width
                let sideB = width * height
                let sideC = height * length
                return (2 * sideA) + (2 * sideB) + (2 * sideC) + [sideA, sideB, sideC].min()!
            }
            
            var ribbonLength: Int {
                let volume = length * width * height
                let twoShortestSides = [length, width, height].sorted(by: <)[0..<2]
                return volume + twoShortestSides[0] + twoShortestSides[0] + twoShortestSides[1] + twoShortestSides[1]
            }
        }
        
        public init() { super.init(inputSource: .file(#file)) }
        
        lazy var boxes: Array<Box> = {
            let regex = Regex(pattern: "(\\d+)x(\\d+)x(\\d+)")
            let lines = input.lines.raw
            
            var boxes = Array<Box>()
            for line in lines {
                let m = regex.match(line)!
                boxes.append(Box(length: Int(m[1]!)!, width: Int(m[2]!)!, height: Int(m[3]!)!))
            }
            return boxes
        }()
        
        override public func part1() -> String {
            let totalSurfaceArea = boxes.map { $0.surfaceArea }.sum()
            return "\(totalSurfaceArea)"
        }
        
        override public func part2() -> String {
            let totalRibbonLength = boxes.map { $0.ribbonLength }.sum()
            return "\(totalRibbonLength)"
        }
        
    }

}
