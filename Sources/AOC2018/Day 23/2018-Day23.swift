//
//  Day23.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day23: Day {
    
    struct Nanobot {
        let x: Int
        let y: Int
        let z: Int
        let r: Int
        
        func canCommunicate(with bot: Nanobot) -> Bool {
            let xDiff = abs(x - bot.x)
            let yDiff = abs(y - bot.y)
            let zDiff = abs(z - bot.z)
            return (xDiff + yDiff + zDiff) <= r
        }
        
        func distance(to x: Int, _ y: Int, _ z: Int) -> Int {
            let xDiff = abs(self.x - x)
            let yDiff = abs(self.y - y)
            let zDiff = abs(self.z - z)
            return xDiff + yDiff + zDiff
        }
    }
    
    lazy var bots: Array<Nanobot> = {
        let r = Regex(pattern: #"pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)"#)
        return input.lines.raw.map { line -> Nanobot in
            let m = line.match(r)
            return Nanobot(x: m.int(1)!, y: m.int(2)!, z: m.int(3)!, r: m.int(4)!)
        }
    }()
    
    override func part1() -> String {
        let sortedBots = bots.sorted { $0.r > $1.r }
        let largestRadius = sortedBots[0]
        
        let count = sortedBots.count(where: { largestRadius.canCommunicate(with: $0) })
        return "\(count)"
    }
    
    override func part2() -> String {
        var (minX, maxX) = bots.map { $0.x }.extremes()
        var (minY, maxY) = bots.map { $0.y }.extremes()
        var (minZ, maxZ) = bots.map { $0.z }.extremes()
        
        func md(_ x: Int, _ y: Int, _ z: Int) -> Int {
            return abs(x) + abs(y) + abs(z)
        }
        
        var gridSize = maxX - minX
        var best: (Int, Int, Int)?
        while gridSize > 0 {
            var maxCount = 0
            
            var x = minX
            while x < maxX {
                
                var y = minY
                while y < maxY {
                    
                    var z = minZ
                    while z < maxZ {
                        
                        var count = 0
                        for bot in bots {
                            let distance = bot.distance(to: x, y, z)
                            if distance - bot.r < gridSize {
                                count += 1
                            }
                        }
                        
                        if maxCount < count {
                            maxCount = count
                            best = (x, y, z)
                        } else if maxCount == count {
                            if best == nil || md(x, y, z) < md(best!.0, best!.1, best!.2) {
                                best = (x, y, z)
                            }
                        }
                        
                        z += gridSize
                    }
                    
                    y += gridSize
                }
                x += gridSize
            }
            
            minX = best!.0 - gridSize
            maxX = best!.0 + gridSize
            minY = best!.1 - gridSize
            maxY = best!.1 + gridSize
            minZ = best!.2 - gridSize
            maxZ = best!.2 + gridSize
            
            gridSize = gridSize / 2
        }
//
        let d = md(best!.0, best!.1, best!.2)
        return "\(d)"
    }
    
}
