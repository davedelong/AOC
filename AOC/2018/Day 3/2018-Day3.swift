//
//  Day3.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//


extension CGRect {
    func positions() -> Set<Position> {
        let xRange = Int(minX) ..< Int(maxX)
        let yRange = Int(minY) ..< Int(maxY)
        
        return Set(xRange.flatMap { x -> Array<Position> in
            return yRange.map { Position(x: x, y: $0) }
        })
    }
}

extension Year2018 {
    
    struct Claim {
        let id: String
        let rect: CGRect
    }

    public class Day3: Day {
        
        private let claimRegex = Regex(pattern: "^\\#(\\d+) @ (\\d+),(\\d+): (\\d+)x(\\d+)$")
        
        lazy var claims: Array<Claim> = {
            let lines = input.trimmed.lines.raw
            let claims = lines.map { line -> Claim in
                let match = claimRegex.match(line)!
                let c = Claim(id: match[1]!, rect: CGRect(x: Double(match[2]!)!,
                                                          y: Double(match[3]!)!,
                                                          width: Double(match[4]!)!,
                                                          height: Double(match[5]!)!))
                return c
            }
            return claims
        }()
        
        public init() { super.init(inputSource: .file(#file)) }
        
        public override func run() -> (String, String) {
            
            var counts = Dictionary<Position, Int>()
            for claim in claims {
                let positions = claim.rect.positions()
                for p in positions {
                    counts[p] = counts[p, default: 0] + 1
                }
            }
            
            let overlaps = counts.values.count(where: { $0 >= 2 })
            
            
            var claimID = ""
            
            for claim in claims {
                var isAlone = true
                for p in claim.rect.positions() {
                    if counts[p] != 1 {
                        isAlone = false
                        break
                    }
                }
                if isAlone == true {
                    claimID = claim.id
                    break
                }
            }
            
            
            return ("\(overlaps)", claimID)
        }
        
    }

}
