//
//  Regex.swift
//  Advent of Code
//
//  Created by Dave DeLong on 12/24/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

public struct Regex {
    
    public static let integers: Regex = #"(-?\d+)"#
    
    internal let pattern: NSRegularExpression
    
    public init(_ pattern: StaticString, options: NSRegularExpression.Options = []) {
        self.pattern = try! NSRegularExpression(pattern: "\(pattern)", options: options)
    }
    
    public init(pattern: String, options: NSRegularExpression.Options = []) throws {
        self.pattern = try NSRegularExpression(pattern: pattern, options: options)
    }
    
    public func matches<S: StringProtocol>(_ string: S) -> Bool  {
        let str = String(string)
        let range = NSRange(location: 0, length: str.utf16.count)
        return pattern.numberOfMatches(in: str, options: [.withTransparentBounds], range: range) > 0
    }
    
    @available(*, deprecated, renamed: "firstMatch(in:)")
    public func match<S: StringProtocol>(_ string: S) -> RegexMatch? {
        return firstMatch(in: string)
    }
    
    public func firstMatch<S: StringProtocol>(in string: S) -> RegexMatch? {
        let str = String(string)
        let range = NSRange(location: 0, length: str.utf16.count)
        guard let match = pattern.firstMatch(in: str, options: [.withTransparentBounds], range: range) else { return nil }
        return RegexMatch(result: match, source: str as NSString)
    }
    
    public func matches<S: StringProtocol>(in string: S) -> Array<RegexMatch> {
        var matches = Array<RegexMatch>()
        
        let str = String(string)
        let range = NSRange(location: 0, length: str.utf16.count)
        pattern.enumerateMatches(in: str, options: [], range: range) { (result, flags, stop) in
            if let result = result {
                let match = RegexMatch(result: result, source: str as NSString)
                matches.append(match)
            }
        }
        
        return matches
    }
}

extension Regex: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) { self.init(value) }
    public init(extendedGraphemeClusterLiteral value: StaticString) { self.init(value) }
    public init(unicodeScalarLiteral value: StaticString) { self.init(value) }
}

extension Regex: ExpressibleByStringInterpolation {
    
    public class StringInterpolation: StringInterpolationProtocol {
        public typealias StringLiteralType = StaticString
        
        internal enum Segment {
            case literal(String)
            case keyedRegex(String, Regex)
            case unkeyedRegex(Regex)
        }
        
        internal var segments = Array<Segment>()
        
        public required init(literalCapacity: Int, interpolationCount: Int) { }
        
        public func appendLiteral(_ literal: StaticString) {
            let string = literal.description
            if string.isEmpty == false { segments.append(.literal(string)) }
        }
        
        public func appendInterpolation<T: RegexDecodable>(_ type: T.Type) {
            segments.append(.unkeyedRegex(T.regex))
        }
        
        public var appendInterpolation: Trampoline { Trampoline(self) }
        
        @dynamicCallable
        public class Trampoline {
            private let interpolation: StringInterpolation
            fileprivate init(_ interpolation: StringInterpolation) {
                self.interpolation = interpolation
            }
            
            public func dynamicallyCall<T: RegexDecodable>(withKeywordArguments args: KeyValuePairs<String, T.Type>) {
                for arg in args {
                    interpolation.segments.append(.keyedRegex(arg.key, arg.value.regex))
                }
            }
            
            public func dynamicallyCall<T: CaseIterable>(withKeywordArguments args: KeyValuePairs<String, T.Type>) where T: RawRepresentable, T.RawValue == String {
                for arg in args {
                    interpolation.segments.append(.keyedRegex(arg.key, arg.value.regex))
                }
            }
        }
    }
    
    public init(stringInterpolation: StringInterpolation) {
        let pattern = stringInterpolation.segments.map { segment -> String in
            switch segment {
                case .literal(let s): return s.regexEscaped
                case .unkeyedRegex(let r): return "(" + r.pattern.pattern + ")"
                case .keyedRegex(let name, let r): return "(?<" + name + ">" + r.pattern.pattern + ")"
            }
        }.joined()
        
        try! self.init(pattern: pattern)
    }
    
}

public struct RegexMatch {
    private let matches: Array<String?>
    
    public var numberOfCaptures: Int { matches.count }
    
    fileprivate init(result: NSTextCheckingResult, source: NSString) {
        var matches = Array<String?>()
        for i in 0 ..< result.numberOfRanges {
            let r = result.range(at: i)
            if r.location == NSNotFound {
                matches.append(nil)
            } else {
                matches.append(source.substring(with: r))
            }
        }
        
        self.matches = matches
    }
    
    public subscript(index: Int) -> String? {
        return matches[index]
    }
    
    public subscript(int index: Int) -> Int? {
        guard let string = self[index] else { return nil }
        return Int(string)
    }
    
    public subscript(char index: Int) -> Character? {
        return self[index]?.first
    }
    
    public subscript(array index: Int) -> Array<Character>? {
        guard let string = self[index] else { return nil }
        return Array(string)
    }
    
    public func int(_ index: Int) -> Int? { return self[int: index] }
    public func char(_ index: Int) -> Character? { self[char: index] }
    public func array(_ index: Int) -> Array<Character>? { self[array: index] }
}

public func ~= (left: Regex, right: String) -> Bool {
    return left.matches(right)
}

public func ~= (left: Regex, right: String) -> RegexMatch? {
    return left.firstMatch(in: right)
}
