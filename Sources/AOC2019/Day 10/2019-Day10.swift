//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/9/17.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//


extension Double {
    static var tau: Double { return 2 * pi }
}
extension XY {
    
    func polarAngle(to other: XY) -> Double {
        return atan2(Double(other.y - self.y), Double(other.x - self.x))
    }
    
}

class Day10: Day {
    
    override func run() -> (String, String) {
        
        // this is all about angles
        // asteroids are "hidden" or occluded if the have the same "angle" from the station as another, closer asteroid
        // ex: if the station is at (0, 0) and an asteroid is at (1,1), then an asteroid at (2,2) is hidden, because
        // the angle from the station to the first asteroid (45º) is the same angle as the angle between the station
        // and the second asteroid
        
        var y = 0
        var asteroids: Array<XY> = input.lines.characters.flatMap { p -> [XY] in
            let a = p.enumerated().compactMap { (idx, char) -> XY? in
                guard char == "#" else { return nil }
                return XY(x: idx, y: y)
            }
            y += 1
            return a
        }
        
        var maxNumberOfSlopes = 0
        var stationLocation: XY = .zero
        
        // this goes through all the asteroid and figures out the angles between the proposed station
        // and all the other asteroids, and counts up the unique angles
        // the first one with the most "wins"
        for asteroid in asteroids {
            var angles = Set<Double>()
            for other in asteroids {
                angles.insert(other.polarAngle(to: asteroid))
            }
            if angles.count > maxNumberOfSlopes {
                maxNumberOfSlopes = angles.count
                stationLocation = asteroid
            }
        }
        
        asteroids.remove(at: asteroids.firstIndex(of: stationLocation)!)
        let p1 = "\(maxNumberOfSlopes)"
        
        // for the second part, we need to group the asteroids by their angle to the station
        // and then start sweeping through them
        var angles = asteroids
            // so we'll group them by their angle (adding tau to make all the angles > 0)
            .groupedBy { ($0.polarAngle(to: stationLocation) + .tau).truncatingRemainder(dividingBy: .tau) }
            
            // and then sort them by manhattan distance to make sure the closest ones are "first" in the array
            .mapValues { $0.sorted(by: { $0.manhattanDistance(to: stationLocation) < $1.manhattanDistance(to: stationLocation) }) }
        
        // next we'll sort the angles themselves, so we know which order to proceed in
        let sortedAngles = angles.keys.sorted(by: <)
        
        var vaporizedCount = 0
        
        // we can't start at 0, because that's pointing LEFT
        // we need to point UP, so we'll find the first angle that's on-or-after 90º (tau/4 radians)
        var angleIndex = sortedAngles.firstIndex(where: { $0 >= (Double.tau / 4) })!
        var mostRecentlyVaporized: XY = .zero
        
        while vaporizedCount < 200 {
            // find the next asteroid to vaporize
            var nextAngle = sortedAngles[angleIndex]
            while angles[nextAngle] == nil || angles[nextAngle]!.isEmpty == true {
                angleIndex += 1
                nextAngle = sortedAngles[angleIndex]
            }
            
            // vaporize it
            mostRecentlyVaporized = angles[nextAngle]!.removeFirst()
            vaporizedCount += 1
            
            // move to the next angle
            angleIndex += 1
            // and wrap back around if we need to
            angleIndex %= sortedAngles.count
        }
        
        let p2 = "\(mostRecentlyVaporized.x * 100 + mostRecentlyVaporized.y)"
        
        return (p1, p2)
    }
}
