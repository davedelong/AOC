//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/30/23.
//

import Foundation
import RegexBuilder

extension Regex where Output == (Substring, Int) {
    
    public static var positiveIntegers: Self {
        Regex {
            Capture {
                OneOrMore(.digit)
            } transform: { Int($0)! }
        }
    }
    
    public static var integers: Self {
        Regex {
            Capture {
                Optionally { "-" }
                OneOrMore(.digit)
            } transform: { Int($0)! }
        }
    }
    
}
