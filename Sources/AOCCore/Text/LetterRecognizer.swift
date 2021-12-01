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
// missing: I, M, Q, S, T, V, W
private let definitions: Dictionary<String, String> = [
    "A":
"""
 ##
#  #
#  #
####
#  #
#  #
""",
    "B":
"""
###
#  #
###
#  #
#  #
###
""",
    "C":
"""
 ##
#  #
#
#
#  #
 ##
""",
    "D":
"""
###
#  #
#  #
#  #
#  #
###
""",
    "E":
"""
####
#
###
#
#
####
""",
    "F":
"""
####
#
###
#
#
#
""",
    "G":
"""
 ##
#  #
#
# ##
#  #
 ###
""",
    "H":
"""
#  #
#  #
####
#  #
#  #
#  #
""",
    "J":
"""
  ##
   #
   #
   #
#  #
 ##
""",
    "K":
"""
#  #
# #
##
# #
# #
#  #
""",
    "L":
"""
#
#
#
#
#
####
""",
    "N":
"""
#  #
## #
## #
# ##
# ##
#  #
""",
    "O":
"""
 ##
#  #
#  #
#  #
#  #
 ##
""",
    "P":
"""
###
#  #
#  #
###
#
#
""",
    "R":
"""
###
#  #
#  #
###
# #
#  #
""",
    "U":
"""
#  #
#  #
#  #
#  #
#  #
 ##
""",
    "X":
"""
#  #
#  #
 ##
 ##
#  #
#  #
""",
    "Y":
"""
#   #
#   #
 # #
  #
  #
  #
""",
    "Z":
"""
####
   #
  #
 #
#
####
"""
]
