//
//  Day13.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day13: Day {

    override func run() -> (String, String) {
        return super.run()
    }

    override func part1() -> String {
        let timestamp = input.lines[0].integer!
        let buses = input.lines[1].integers
        
        var bus = 0
        var wait = Int.max
        var departure = Int.max
        
        for nextBus in buses {
            if timestamp % nextBus == 0 {
                // wait 0 minutes
                return "0"
            } else {
                let d = nextBus * ((timestamp+nextBus)/nextBus)
                let waitForBus = d - timestamp
                
                if d < departure {
                    departure = d
                    wait = waitForBus
                    bus = nextBus
                }
            }
        }
        
        
        return "\(bus * wait)"
    }
    
    func p2() {
        /*
         x+0 % 17 == 0      => x + 0 % 17 = 0   => x % 17 = 0       => x % 17 = 0
         x+7 % 41 == 0      => x + 7 % 41 = 0   => x % 41 = 41-7    => x % 41 = 34
         x+11 % 37 == 0     => x +11 % 37 = 0   => x % 37 = 37-11   => x % 37 = 26
         x+17 % 367 == 0    => x +17 %367 = 0   => x %367 = 367-17  => x %367 = 350
         x+36 % 19 == 0     => x +17 % 19 = 0   => x % 19 = 19-17   => x % 19 = 2
         x+40 % 23 == 0     => x +17 % 23 = 0   => x % 23 = 23-17   => x % 23 = 6
         x+46 % 29 == 0     => x +17 % 29 = 0   => x % 29 = 29-17   => x % 29 = 12
         x+48 % 613 == 0    => x +48 %613 = 0   => x %613 = 613-48  => x %613 = 565
         x+61 % 13 == 0     => x + 9 % 13 = 0   => x % 13 = 13-9    => x % 13 = 4
        */
        
    }
    
    override func part2() -> String {
        /*
         x+0 % 17 == 0      => x+17 % 17    => x+816 % 17
         x+7 % 41 == 0      => x+48 % 41    => x+816 % 41
         x+11 % 37 == 0     => x+48 % 37    => x+816 % 37
         x+17 % 367 == 0    => x+17 % 367   => x+816 % 367
         x+36 % 19 == 0     => x+17 % 19    => x+816 % 19
         x+40 % 23 == 0     => x+17 % 23    => x+816 % 23
         x+46 % 29 == 0     => x+17 % 29    => x+816 % 29
         x+48 % 613 == 0    => x+48 % 613   => x+816 % 613
         x+61 % 13 == 0     => x+48 % 13    => x+816 % 13
         =====================================================

         x+48 % (41 * 37 * 613 * 13)
         x+17 % (17 * 367 * 19 * 23 * 29)

         x+816 % 955836978578131 = 0
         x % 955836978578131 = (955836978578131-816) = 955836978577315
         
         =====================================================

        x+48 % 12088973    = 0
        x+17 % 79066847     = 0
         
         */
        
        let s = stride(from: 955836978577315, to: Int.max, by: 955836978578131)
            .first(where: {
                    $0 % 955_836_978_578_131 == 816
            })
        
        print(s)
        
        let stride = 12088973
        var xWithOffset = stride // x+48
        
        var answer = 0
        while true {
            if (xWithOffset - 31) % 79066847 == 0 {
                answer = xWithOffset-48
                break
            }
            xWithOffset += stride
        }
        
        let pairs = input.lines[1].csvWords.enumerated().compactMap { (index, word) -> (Int, Int)? in
            guard let int = word.integer else { return nil }
            return (index, int)
        }
        
        for (offset, bus) in pairs {
            if (answer+offset) % bus != 0 {
                fatalError("shit's fucked: \(answer) % \(bus) ≠ \(offset)")
            }
        }
        
        return "\(answer)"
        /*
        let maxPair = pairs.max(by: { $0.1 < $1.1 })!
        
        let s = stride(from: maxPair.1 - maxPair.0, through: Int.max, by: maxPair.1)
        
        var attempt = 0
        let timestamp = s.first(where: { ts in
            attempt += 1
            if attempt % 1000 == 0 { print(ts) }
            for (offset, divisor) in pairs {
                if (ts + offset) % divisor != 0 { return false }
            }
            return true
        })!
        
        return "\(timestamp)"
 */
    }

}
