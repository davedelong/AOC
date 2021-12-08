//
//  Day8.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import Foundation

class Day8: Day {

    typealias Digit = Set<Character>

    override func part1() -> String {
        let words = input.lines.words.raw.flatMap { words -> Array<Digit> in
            let index = words.firstIndex(of: "|")!
            let slice = words[index+1 ..< words.count]
            return slice.map { Digit($0) }
        }
        
        let ones = words.count(where: { $0.count == 2 })
        let fours = words.count(where: { $0.count == 4 })
        let sevens = words.count(where: { $0.count == 3 })
        let eights = words.count(where: { $0.count == 7 })
        return "\(ones + fours + sevens + eights)"
    }

    override func part2() -> String {
        let numbers = input.lines.words.raw.map { words -> Int in
            let index = words.firstIndex(of: "|")!
            
            let input = words[0 ..< index ].map { Digit($0) }
            let output = words[index + 1 ..< words.count].map { Digit($0) }
            
            return deduce(signals: input, output: output)
        }
        
        return "\(numbers.sum)"
    }
    
    /*
     
     
     
     
     
     
     
     
     0:      1:      2:      3:      4:
    aaaa    ....    aaaa    aaaa    ....
   b    c  .    c  .    c  .    c  b    c
   b    c  .    c  .    c  .    c  b    c
    ....    ....    dddd    dddd    dddd
   e    f  .    f  e    .  .    f  .    f
   e    f  .    f  e    .  .    f  .    f
    gggg    ....    gggg    gggg    ....

     5:      6:      7:      8:      9:
    aaaa    aaaa    aaaa    aaaa    aaaa
   b    .  b    .  .    c  b    c  b    c
   b    .  b    .  .    c  b    c  b    c
    dddd    dddd    ....    dddd    dddd
   .    f  e    f  .    f  e    f  .    f
   .    f  e    f  .    f  e    f  .    f
    gggg    gggg    ....    gggg    gggg
     */
    
    func deduce(signals: Array<Digit>, output: Array<Digit>) -> Int {
        var maps = Dictionary<Digit, Int>()
        
        var remaining = Set(signals + output)
        
        // every input has one of these
        let one = remaining.first(where: { $0.count == 2 })!
        let four = remaining.first(where: { $0.count == 4 })!
        let seven = remaining.first(where: { $0.count == 3 })!
        let eight = remaining.first(where: { $0.count == 7 })!
        
        var aPossible = Set("abcdefg")
        var bPossible = Set("abcdefg")
        var cPossible = Set("abcdefg")
        var dPossible = Set("abcdefg")
        var ePossible = Set("abcdefg")
        var fPossible = Set("abcdefg")
        var gPossible = Set("abcdefg")
        
        maps[one] = 1
        remaining.remove(one)
        
        maps[four] = 4
        remaining.remove(four)
        
        maps[seven] = 7
        remaining.remove(seven)
        
        maps[eight] = 8
        remaining.remove(eight)
        
        aPossible = seven.subtracting(one) // DONE
        bPossible = four.subtracting(one)
        dPossible = four.subtracting(one)
        
        let nineSearch = four.union(aPossible)
        let nine = remaining.first(where: { $0.isSuperset(of: nineSearch) })!
        remaining.remove(nine)
        maps[nine] = 9
        gPossible = nine.subtracting(nineSearch) // DONE
        ePossible = eight.subtracting(nine) // DONE
        
        var _six: Digit?
        for cf in one {
            let sixSearch = eight.subtracting([cf])
            if let six = remaining.first(where: { $0 == sixSearch }) {
                _six = six
                break
            }
        }
        let six = _six!
        remaining.remove(six)
        maps[six] = 6
        
        cPossible = eight.subtracting(six) // DONE
        fPossible = fPossible.subtracting(cPossible) // DONE
        
        // missing b and d at this point
        assert(bPossible.count == 2 && bPossible == dPossible)
        var _zero: Digit?
        for bd in bPossible {
            let zeroMatch = eight.subtracting([bd])
            if let zero = remaining.first(where: { $0 == zeroMatch }) {
                dPossible = [bd] // DONE
                bPossible = bPossible.subtracting(dPossible) // DONE
                _zero = zero; break
            }
        }
        let zero = _zero!
        remaining.remove(zero)
        maps[zero] = 0
        
        fPossible = eight.subtracting(aPossible + bPossible + cPossible + dPossible + ePossible + gPossible)
        
        [aPossible, bPossible, cPossible, dPossible, ePossible, fPossible, gPossible].forEach {
            assert($0.count == 1)
        }
        
        let digits = [
            aPossible + bPossible + cPossible + ePossible + fPossible + gPossible: 0,
            cPossible + fPossible: 1,
            aPossible + cPossible + dPossible + ePossible + gPossible: 2,
            aPossible + cPossible + dPossible + fPossible + gPossible: 3,
            bPossible + cPossible + dPossible + fPossible: 4,
            aPossible + bPossible + dPossible + fPossible + gPossible: 5,
            aPossible + bPossible + dPossible + ePossible + fPossible + gPossible: 6,
            aPossible + cPossible + fPossible: 7,
            aPossible + bPossible + cPossible + dPossible + ePossible + fPossible + gPossible: 8,
            aPossible + bPossible + cPossible + dPossible + fPossible + gPossible: 9
        ]
        
        let something = output.map { digits[$0]! }
        return Int(digits: something)
    }

}
