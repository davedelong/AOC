//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/15/20.
//

import Foundation

public func RecognizeLetters(from input: String) -> String {
    let splits = input.split(on: "\n")
    let maxLength = splits.map(\.count).max()!
    
    let lines = splits.map { $0.padding(toLength: maxLength, with: " ") }
    
    var recognized = ""
    var candidates = Array<Letter>()
    
    for i in 0 ..< maxLength {
        let inputSlice = lines.map { $0[offset: i] }
        
        if inputSlice.allSatisfy(\.isWhitespace) {
            // it's blank...
            if let match = candidates.first {
                recognized.append(match.character)
                candidates = []
            }
        } else {
            if candidates.isEmpty {
                candidates = Letter.all
            }
            
            var remainingCandidates = Array<Letter>()
            var foundExactMatch = false
            
            for c in candidates {
                // candidate is empty; ignore it
                if c.pattern.allSatisfy(\.isEmpty) { continue }
                
                var copy = c
                let slice = copy.pattern.mutatingMap { $0.removeFirst() }
                if slice != inputSlice { continue }
                
                // it's a match
                if copy.pattern.allSatisfy(\.isEmpty) {
                    // it's an *exact* match
                    recognized.append(copy.character)
                    foundExactMatch = true
                } else {
                    remainingCandidates.append(copy)
                }
            }
            
            if foundExactMatch {
                candidates = []
            } else {
                candidates = remainingCandidates
            }
        }
    }
    
    if let match = candidates.first {
        recognized.append(match.character)
    }
    
    return recognized
    
}

struct Letter {
    let character: Character
    var pattern: Array<Array<Character>>
    
    let height: Int
    let width: Int
    
    init(character: Character, pattern: String) {
        self.character = character
        
        let lines = pattern.split(separator: "\n")
        let width = lines.map(\.count).max()!
        
        self.width = width
        self.height = lines.count
        
        self.pattern = lines.map { line in
            return Array(line.padding(toLength: width, withPad: " ", startingAt: 0))
        }
    }
}

extension Letter {
    // missing: I, M, Q, S, T, V, W
    static let all = [a, b, c, d, e, f, g, h, j, k, l, n, o, p, r, u, x, y, z]
    
    static let a = Letter(character: "A", pattern: """
 ##
#  #
#  #
####
#  #
#  #
""")
    static let b = Letter(character: "B", pattern: """
###
#  #
###
#  #
#  #
###
""")
    static let c = Letter(character: "C", pattern: """
 ##
#  #
#
#
#  #
 ##
""")
    static let d = Letter(character: "D", pattern: """
###
#  #
#  #
#  #
#  #
###
""")
    static let e = Letter(character: "E", pattern: """
####
#
###
#
#
####
""")
    static let f = Letter(character: "F", pattern: """
####
#
###
#
#
#
""")
    static let g = Letter(character: "G", pattern: """
 ##
#  #
#
# ##
#  #
 ###
""")
    static let h = Letter(character: "H", pattern: """
#  #
#  #
####
#  #
#  #
#  #
""")
    static let j = Letter(character: "J", pattern: """
  ##
   #
   #
   #
#  #
 ##
""")
    static let k = Letter(character: "K", pattern: """
#  #
# #
##
# #
# #
#  #
""")
    static let l = Letter(character: "L", pattern: """
#
#
#
#
#
####
""")
    static let n = Letter(character: "N", pattern: """
#  #
## #
## #
# ##
# ##
#  #
""")
    static let o = Letter(character: "O", pattern: """
 ##
#  #
#  #
#  #
#  #
 ##
""")
    static let p = Letter(character: "P", pattern: """
###
#  #
#  #
###
#
#
""")
    static let r = Letter(character: "R", pattern: """
###
#  #
#  #
###
# #
#  #
""")
    static let u = Letter(character: "U", pattern: """
#  #
#  #
#  #
#  #
#  #
 ##
""")
    static let x = Letter(character: "X", pattern: """
#  #
#  #
 ##
 ##
#  #
#  #
""")
    static let y = Letter(character: "Y", pattern: """
#   #
#   #
 # #
  #
  #
  #
""")
    static let z = Letter(character: "Z", pattern: """
####
   #
  #
 #
#
####
""")
}
