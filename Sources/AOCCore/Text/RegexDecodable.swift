//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/2/21.
//

import Foundation
import Combine

public protocol RegexDecodable: Decodable {
    static var regex: Regex { get }
}

extension CaseIterable where Self: RawRepresentable, RawValue == String {
    static var regex: Regex {
        let pattern = "(" + self.allCases.map(\.rawValue.regexEscaped).joined(separator: "|") + ")"
        return try! Regex(pattern: pattern)
    }
}

extension Int: RegexDecodable {
    public static var regex: Regex { Regex(#"-?\d+"#) }
}

extension UInt: RegexDecodable {
    public static var regex: Regex { Regex(#"\d+"#) }
}

//extension Double: RegexDecodable {
//    public static var regex: Regex { Regex(#"-?\d+"#) }
//}
