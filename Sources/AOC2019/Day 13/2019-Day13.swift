//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/13/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

import AppKit

fileprivate let SHOULD_GENERATE_GIF = false

class Day13: Day {
    
    enum Tile: Int {
        case empty = 0
        case wall = 1
        case block = 2
        case paddle = 3
        case ball = 4
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    override func part1() -> String {
        let i = Intcode(memory: input.integers)
        
        var final = Dictionary<XY, Tile>()
        var next = Array<Int>()
        while i.isHalted == false {
            i.runUntilAfterNextOutput()
            next.append(i.io!)
            if next.count == 3 {
                let xy = XY(x: next[0], y: next[1])
                let tile = Tile(rawValue: next[2])!
                final[xy] = tile
                
                next.removeAll()
            }
        }
        
        let c = final.values.count(where: { $0 == .block })
        return "\(c)"
    }
    
    override func part2() -> String {
        let i = Intcode(memory: input.integers)
        i.memory[0] = 2
        
        var grid = Dictionary<XY, Tile>()
        
        var next = Array<Int>()
        var score = 0
        
        var ballPositionX = 0
        var paddlePositionX = 0
        
        
        let url = URL(fileURLWithPath: "/tmp/2019-13.gif")
        let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypeGIF, 0, nil)!
        
        let frameProperty = [
            kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: 0.01]
        ]
        
        while i.isHalted == false {
            i.runUntilBeforeNextIO()
            if i.isHalted { break }
            if i.needsIO() {
                // will read
                if paddlePositionX < ballPositionX {
                    i.io = 1
                } else if paddlePositionX > ballPositionX {
                    i.io = -1
                } else {
                    i.io = 0
                }
                
                i.step()
            } else {
                i.step()
                next.append(i.io!)
                if next.count == 3 {
                    let xy = XY(x: next[0], y: next[1])
                    if xy == XY(x: -1, y: 0) {
                        score = next[2]
                    } else {
                        let tile = Tile(rawValue: next[2])!
                        grid[xy] = tile
                        
                        if tile == .ball { ballPositionX = xy.x }
                        if tile == .paddle { paddlePositionX = xy.x }
                    }
                    
                    next.removeAll()
                }
            }
//            draw(grid: final)
            if SHOULD_GENERATE_GIF {
                autoreleasepool {
                    if let f = drawFrame(grid), let data = f.tiffRepresentation {
                        let img = CGImageSourceCreateWithData(data as CFData, nil)!
                        CGImageDestinationAddImageFromSource(destination, img, 0, frameProperty as CFDictionary)
                    }
                }
            }
            
        }
        
        if SHOULD_GENERATE_GIF {
            let gifProperties = [
                kCGImagePropertyGIFDictionary: [
                    kCGImagePropertyColorModel: kCGImagePropertyColorModelRGB,
                    kCGImagePropertyGIFHasGlobalColorMap: true
                ]
            ]
            CGImageDestinationSetProperties(destination, gifProperties as CFDictionary)
            CGImageDestinationFinalize(destination)
            
            print("Created gif at \(url.path)")
        }
        
        return "\(score)"
    }
    
    private func draw(grid: Dictionary<XY, Tile>) {
        guard grid.isNotEmpty else { return }
        let xRange = grid.keys.map { $0.x }.range()
        let yRange = grid.keys.map { $0.y }.range()
        
        // the code generates a 40x21 grid
        guard xRange.count == 40 else { return }
        guard yRange.count == 21 else { return }
        
        for y in yRange {
            for x in xRange {
                let t = grid[XY(x: x, y: y)] ?? .empty
                let s: String
                switch t {
                    case .empty: s = " "
                    case .ball: s = "●"
                    case .block: s = "▢"
                    case .wall:
                        if x == xRange.lowerBound {
                            if y == yRange.lowerBound {
                                s = "┏"
                            } else if y == yRange.upperBound {
                                s = "┗"
                            } else {
                                s = "┃"
                            }
                        } else if x == xRange.upperBound {
                            if y == yRange.lowerBound {
                                s = "┓"
                            } else if y == yRange.upperBound {
                                s = "┛"
                            } else {
                                s = "┃"
                            }
                        } else {
                            s = "━"
                        }
                    case .paddle: s = "▂"
                }
                print(s, terminator: "")
            }
            print("")
        }
    }
    
    private func drawFrame(_ grid: Dictionary<XY, Tile>) -> NSImage? {
        guard grid.isNotEmpty else { return nil }
        let xRange = grid.keys.map { $0.x }.range()
        let yRange = grid.keys.map { $0.y }.range()
        
        // the code generates a 40x21 grid
        guard xRange.count == 40 else { return nil }
        guard yRange.count == 21 else { return nil }
        
        var foundPaddle = false
        var foundBall = false
        for t in grid.values {
            if t == .ball { foundBall = true }
            if t == .paddle { foundPaddle = true }
        }
        if foundPaddle == false { return nil }
        if foundBall == false { return nil }
        
        let pixelDensity = 2
        let i = NSImage(size: NSSize(width: xRange.count * pixelDensity, height: yRange.count * pixelDensity), flipped: true) { _ in
            let cg = NSGraphicsContext.current!.cgContext
            NSColor.white.setFill()
            cg.fill(CGRect(x: 0, y: 0, width: xRange.count * pixelDensity, height: yRange.count * pixelDensity))
            
            for x in xRange {
                for y in yRange {
                    let xy = XY(x: x, y: y)
                    guard let t = grid[xy] else { continue }
                    guard t != .empty else { continue }
                    
                    switch t {
                        case .ball: NSColor.blue.set()
                        case .block: NSColor.gray.set()
                        case .wall: NSColor.black.set()
                        case .paddle: NSColor.red.set()
                        default: continue
                    }
                    
                    cg.fill(CGRect(x: x * pixelDensity, y: y * pixelDensity, width: pixelDensity, height: pixelDensity))
                }
            }
            return true
        }
        return i
    }
    
}
