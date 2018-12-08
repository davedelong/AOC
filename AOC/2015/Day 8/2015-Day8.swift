//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/7/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

extension Year2015 {

    public class Day8: Day {
        
        public init() { super.init(inputSource: .file(#file)) }
        
        override public func part1() -> String {
            let linesOfCharacters = input.lines.characters
            let numberOfCodeCharacters = linesOfCharacters.map { $0.count }.sum()
            
            let cleaned = linesOfCharacters.map { chars -> String in
                var final = ""
                // drop the opening and closing quote
                var contents = Array(chars.dropFirst().dropLast())
                var index = 0
                while index < contents.count {
                    if contents[index] == "\\" && contents[index+1] == "x" && contents[index+2].isHexDigit && contents[index+3].isHexDigit {
                        let hexString = String(contents[index+2...index+3])
                        let hexValue = UInt16(hexString, radix: 16)!
                        let s = String(format: "%c", hexValue)
                        final.append(s)
                        index += 3
                    } else if contents[index] == "\\" {
                        index += 1
                        final.append(contents[index])
                    } else {
                        final.append(contents[index])
                    }
                    
                    
                    index += 1
                }
                
                return final
            }
            let numberOfCleanedCharacters = cleaned.map { $0.count }.sum()
            
            return "\(numberOfCodeCharacters - numberOfCleanedCharacters)"
        }
        
        override public func part2() -> String {
            let linesOfCharacters = input.lines.characters
            
            let encodedCharacters = linesOfCharacters.map { chars -> String in
                var final = "\""
                for c in chars {
                    if c == "\"" || c == "\\" { final.append("\\") }
                    final.append(c)
                }
                final.append("\"")
                return final
            }
            
            let encodedCharacterCount = encodedCharacters.map { $0.count }.sum()
            let originalCharacterCount = linesOfCharacters.map { $0.count }.sum()
            let difference = encodedCharacterCount - originalCharacterCount
            return "\(difference)"
            
        }
        
    }

}
