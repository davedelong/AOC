//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/15/20.
//

import Foundation

public func RecognizeLetters(from input: String, letterCharacter: Character = "#") -> String {
    return RecognizeLetters(from: input, isLetterCharacter: { $0 == letterCharacter })
}

public func RecognizeLetters(from input: String, isLetterCharacter: (Character) -> Bool) -> String {
    let splits = input.split(on: "\n")
    let maxLength = splits.map(\.count).max()!
    
    let lines = splits.map {
        $0.padding(toLength: maxLength, with: " ").map(isLetterCharacter)
    }
    return RecognizeLetters(in: lines)
}

public func RecognizeLetters<C: Collection>(in collection: C, isLetterCharacter: (C.Element.Element) -> Bool) -> String where C.Element: Collection {
    let linesOfBools = collection.map { $0.map(isLetterCharacter) }
    return RecognizeLetters(in: linesOfBools)
}

public func RecognizeLetters<C: Collection>(in collection: C) -> String where C.Element: Collection, C.Element.Element == Bool {
    let maxWidth = collection.max(of: \.count)
    let lines = collection.map { $0.padded(toLength: maxWidth, with: false) }
    
    lines.forEach { line in
        line.forEach { print($0 ? "⬛️" : "⬜️", separator: "", terminator: "") }
        print("")
    }
    
    let blanksRemoved = lines.filter { $0.anySatisfy(\.isTrue) }
    
    let scannedLines = blanksRemoved.chunks(ofCount: Letter.letterHeight).map { scanLetters(in: $0) }
    return scannedLines.joined(separator: "\n")
}

private func scanLetters(in lines: ArraySlice<[Bool]>) -> String {
    var recognized = ""
    var candidates = Array<Letter>()
    
    for i in 0 ..< lines[0].count {
        let inputSlice = lines.map { $0[offset: i] }
        
        if inputSlice.allSatisfy(\.isFalse) {
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

private struct Letter {
    let character: Character
    var pattern: Array<Array<Bool>>
    
    let height: Int
    let width: Int
    
    init(character: Character, pattern: String) {
        self.character = character
        
        let lines = pattern.split(separator: "\n")
        let width = lines.map(\.count).max()!
        
        self.width = width
        self.height = lines.count
        
        self.pattern = lines.map { line in
            return (line.map { $0 == "#" }).padded(toLength: width, with: false)
        }
    }
}

extension Letter {
    // missing: I, M, Q, S, T, V, W
    static let all = [a, b, c, d, e, f, g, h, j, k, l, n, o, p, r, u, x, y, z]
    static let letterHeight = all.max(of: \.height)
    
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
