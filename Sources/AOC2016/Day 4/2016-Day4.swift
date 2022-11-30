//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 12/23/17.
//  Copyright © 2016 Dave DeLong. All rights reserved.
//

class Day4: Day {
    
    let regex = Regex(#"(.+?)-(\d+)\[(.+?)\]"#)
    
    func run() async throws -> (Int, Int) {
        
        var sectorSum = 0
        var npSector = 0
        
        for raw in input().lines.raw {
            guard let match = regex.firstMatch(in: raw) else { continue }
            let room = match[1]!
            let sector = match[int: 2]!
            let checksum = match[3]!
            
            let roomLetters = room.filter(\.isLetter).countElements()
            let lettersByFrequency = roomLetters.sorted(by: {
                if $0.value > $1.value { return true }
                if $0.value < $1.value { return false }
                return $0.key < $1.key
            })
            
            let fiveMostCommon = lettersByFrequency.prefix(5)
            let expectedChecksum = String(fiveMostCommon.map(\.key))
            guard checksum == expectedChecksum else { continue }
            
            // this is a valid room
            sectorSum += sector
            
            // decode the name
            if npSector == 0 {
                let decodedName = decode(room, shift: sector)
                if decodedName == "northpole object storage" {
                    npSector = sector
                }
            }
        }
        return (sectorSum, npSector)
    }
    
    private func decode(_ name: String, shift: Int) -> String {
        let alpha = Character.alphabet
        
        return String(name.map { c -> Character in
            if c == "-" { return " " }
            
            let idx = alpha.firstIndex(of: c)!
            let newIdx = (idx + shift).quotientAndRemainder(dividingBy: alpha.count).remainder
            return alpha[newIdx]
        })
        
    }

}
