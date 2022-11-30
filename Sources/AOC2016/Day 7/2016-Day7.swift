//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/5/17.
//  Copyright © 2016 Dave DeLong. All rights reserved.
//

import Foundation

class Day7: Day {
    
    struct IP {
        // stuff outside the square brackets
        var supernetSequences: [String]
        
        // stuff inside square brackets
        var hypernetSequences: [String]
        
        var supportsTLS: Bool {
            func containsABBA(_ string: String) -> Bool {
                for window in string.windows(ofCount: 4) {
                    if window.isPalindrome() && window.first! != window.second! { return true }
                }
                return false
            }
            
            if hypernetSequences.contains(where: containsABBA(_:)) { return false }
            return supernetSequences.contains(where: containsABBA(_:))
        }
        
        var supportsSSL: Bool {
            struct ABA {
                let a: Character
                let b: Character
            }
            
            func ABAs(_ string: String) -> Array<ABA> {
                return string.windows(ofCount: 3).compactMap { w -> ABA? in
                    guard w.isPalindrome() else { return nil }
                    guard w.first != w.second else { return nil }
                    return ABA(a: w.first!, b: w.second!)
                }
            }
            
            let potentialABAs = supernetSequences.flatMap(ABAs(_:))
            for aba in potentialABAs {
                let bab = String([aba.b, aba.a, aba.b])
                for hypernetSequence in hypernetSequences {
                    for window in hypernetSequence.windows(ofCount: 3) {
                        if window.elementsEqual(bab) { return true }
                    }
                }
            }
            return false
        }
    }
    
    lazy var IPs: Array<IP> = {
        return input().lines.raw.map { raw -> IP in
            var ip = IP(supernetSequences: [], hypernetSequences: [])
            
            for piece in raw.split(on: "[") {
                let subpieces = piece.split(on: "]")
                if subpieces.count == 1 {
                    ip.supernetSequences.append(String(subpieces[0]))
                } else if subpieces.count == 2 {
                    ip.hypernetSequences.append(String(subpieces[0]))
                    ip.supernetSequences.append(String(subpieces[1]))
                }
            }
            
            return ip
        }
    }()
    
    func part1() async throws -> Int {
        return IPs.count(where: \.supportsTLS)
    }
    
    func part2() async throws -> Int {
        return IPs.count(where: \.supportsSSL)
    }

}
