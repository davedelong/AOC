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
        var remaining = Set(signals)
        
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
        
        remaining.remove(one)
        remaining.remove(four)
        remaining.remove(seven)
        remaining.remove(eight)
        
        aPossible = seven.subtracting(one) // DONE
        bPossible = four.subtracting(one)
        dPossible = four.subtracting(one)
        
        // add the "a" line to the four digit
        // use that to search for the remaining digit that has all those segments
        // that's the nine digit
        let nineSearch = four.union(aPossible)
        let nine = remaining.first(where: { $0.isSuperset(of: nineSearch) })!
        remaining.remove(nine)
        
        // the segment that was missing from the search set is the "g" segment
        gPossible = nine.subtracting(nineSearch) // DONE
        
        // the segment that eight has that nine doesn't is the "e" segment
        ePossible = eight.subtracting(nine) // DONE
        
        // the remaining digit that has one of the possible one segments missing
        // is the six digit
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
        
        // the thing that was missing from the six is the "c" segment
        cPossible = eight.subtracting(six) // DONE
        
        // the other part of the one digit is the "f" segment
        fPossible = one.subtracting(cPossible) // DONE
        
        // missing b and d at this point
        assert(bPossible.count == 2 && bPossible == dPossible)
        
        // subtract one of the two possibilities of b/d from eight
        // the remaining digit that matches is zero
        var _zero: Digit?
        for bd in bPossible {
            let zeroMatch = eight.subtracting([bd])
            if let zero = remaining.first(where: { $0 == zeroMatch }) {
                
                // the thing that was used to find zero is the missing "d" segment
                dPossible = [bd] // DONE
                // and the other half of the b/d pair is the "b" segment
                bPossible = bPossible.subtracting(dPossible) // DONE
                _zero = zero; break
            }
        }
        let zero = _zero!
        remaining.remove(zero)
        
        // at this point, we've identified every segment!
        // just to make sure...
        [aPossible, bPossible, cPossible, dPossible, ePossible, fPossible, gPossible].forEach {
            assert($0.count == 1)
        }
        
        // using the definitions above, we now know what each digit is made of:
        let digitSegments = [
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
        
        // figure out what the four-digit number is
        let digits = output.map { digitSegments[$0]! }
        return Int(digits: digits)
    }

}
