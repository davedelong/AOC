//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/13/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day14: Day {
    
    struct ReindeerState {
        var points: Int
        var distanceTraveled: Int
        var timeRemaining: Int
        var isResting: Bool
    }
    
    struct Reindeer {
        let velocity: Int
        let travelTime: Int
        let restTime: Int
    }
    
    lazy var reindeer: Dictionary<String, Reindeer> = {
        let r = Regex(#"(.+?) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds\."#)
        let tuples = input().lines.raw.map { l -> (String, Reindeer) in
            let m = r.firstMatch(in: l)!
            return (m[1]!, Reindeer(velocity: m.int(2)!, travelTime: m.int(3)!, restTime: m.int(4)!))
        }
        return Dictionary(uniqueKeysWithValues: tuples)
    }()
    
    func run() async throws -> (String, String) {
        var state = Dictionary<String, ReindeerState>()
        
        for (name, r) in reindeer {
            state[name] = ReindeerState(points: 0, distanceTraveled: 0, timeRemaining: r.travelTime, isResting: false)
        }
        
        for _ in 0 ..< 2503 {
            for (name, r) in reindeer {
                var s = state[name]!
                if s.isResting == false {
                    s.distanceTraveled += r.velocity
                }
                s.timeRemaining -= 1
                if s.timeRemaining == 0 {
                    s.isResting.toggle()
                    if s.isResting {
                        s.timeRemaining = r.restTime
                    } else {
                        s.timeRemaining = r.travelTime
                    }
                }
                state[name] = s
            }
            
            let furthest = state.values.map { $0.distanceTraveled }.max()!
            for (name, r) in state {
                if r.distanceTraveled == furthest {
                    var newState = r
                    newState.points += 1
                    state[name] = newState
                }
            }
        }
        
        let furthestReindeer = state.values.map { $0.distanceTraveled }.max()!
        let mostPoints = state.values.map { $0.points }.max()!
        
        return ("\(furthestReindeer)", "\(mostPoints)")
    }
    
}
