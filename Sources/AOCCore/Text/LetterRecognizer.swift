//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/15/20.
//

import Foundation

// missing: I, M, Q, S, T, V, W
private let alphabet = "ABCDEFGHJKLNOPRUXYZ"
private let letters = """
 ##  ###   ##  ###  #### ####  ##  #  #   ## #  # #    #  #  ##  ###  ###  #  # #  # #   # ####
#  # #  # #  # #  # #    #    #  # #  #    # # #  #    ## # #  # #  # #  # #  # #  # #   #    #
#  # ###  #    #  # ###  ###  #    ####    # ##   #    ## # #  # #  # #  # #  #  ##   # #    #
#### #  # #    #  # #    #    # ## #  #    # # #  #    # ## #  # ###  ###  #  #  ##    #    #
#  # #  # #  # #  # #    #    #  # #  # #  # # #  #    # ## #  # #    # #  #  # #  #   #   #
#  # ###   ##  ###  #### #     ### #  #  ##  #  # #### #  #  ##  #    #  #  ##  #  #   #   ####
"""

fileprivate let letterDefinitions: Dictionary<String, String> = {
    var final = Dictionary<String, String>()

    let defs = chunk(input: letters)
    for (definition, character) in zip(defs, alphabet) {
        final[definition] = String(character)
    }
    return final
}()

fileprivate func chunk(input: String, trimming: Int = 0) -> Array<String> {
    let lines = input.components(separatedBy: .newlines)
    
    var final = Array<String>()
    
    for lineGroup in lines.chunks(of: 6) { // letters are 6 lines tall
        var remaining = lineGroup.map { $0.dropFirst(trimming) }
        while remaining.allSatisfy({ $0.isNotEmpty }) {
            let fragments = remaining.map { $0.prefix(5) } // letters are five characters wide
            remaining = remaining.map { $0.dropFirst(5) } // letters are followed by a space
            let character = fragments.joined(separator: "\n")
            final.append(character)
        }
    }
    
    return final
}

public func RecognizeLetters(from input: String) -> String {
    var recognized = ""
    for trimLength in 0 ..< 5 {
        let chunks = chunk(input: input, trimming: trimLength)
        
        let letters = chunks.compactMap { letterDefinitions[$0] }
        if letters.isNotEmpty {
            recognized = letters.joined()
            break
        }
    }
    return recognized
    
}

struct Letter {
    let character: Character
    let pattern: String
    
    let height: Int
    let width: Int
    
    init(character: Character, pattern: String) {
        self.character = character
        self.pattern = pattern
        
        let lines = pattern.split(separator: "\n")
        self.height = lines.count
        self.width = lines.map(\.count).max()!
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
