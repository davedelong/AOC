//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day3: Day {
    
    struct Claim {
        let id: String
        let positions: Set<Position>
    }
    
    lazy var claims: Array<Claim> = {
        let claimRegex = Regex(#"^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$"#)
        let claims = input.lines.raw.map { line -> Claim in
            let match = claimRegex.firstMatch(in: line)!
            
            let x = match.int(2)!
            let y = match.int(3)!
            let width = match.int(4)!
            let height = match.int(5)!
            let positions = (x ..< (x+width)).flatMap { x -> Array<Position> in
                return (y ..< (y+height)).map { Position(x: x, y: $0) }
            }
            return Claim(id: match[1]!, positions: Set(positions))
        }
        return claims
    }()
    
    override func run() -> (String, String) {
        let counts = CountedSet(counting: claims.flatMap { $0.positions })
        let part1 = counts.values.count(where: { $0 >= 2 })
        let part2 = claims.first { c in c.positions.allSatisfy { counts[$0] == 1 } }!.id
        return ("\(part1)", part2)
    }
    
}
