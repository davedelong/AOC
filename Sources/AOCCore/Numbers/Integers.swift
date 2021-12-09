//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/3/19.
//

import Foundation

extension FixedWidthInteger {
    
    public var onesDigit: Self.Magnitude {
        return magnitude % 10
    }
    
    public var digits: Array<Self> {
        var d = Array<Self>()
        var remainder = self
        if remainder < 0 { remainder *= -1 }
        
        while remainder > 0 {
            let m = remainder % 10
            d.append(m)
            remainder /= 10
        }
        return Array(d.reversed())
    }
    
    public var bits: Array<Bool> {
        var bits = Array<Bool>()
        for offset in 0 ..< Self.bitWidth {
            bits.append((self & (1 << offset)) > 0)
        }
        return bits.reversed()
    }
    
}

public extension Int {
    
    init<C: Collection>(bits: C) where C.Element == Bool {
        self = bits.reduce(0, { $0 * 2 + ($1 ? 1 : 0) })
    }
    
    init<C: Collection>(digits: C) where C.Element == Int {
        var i = 0
        for (power, digit) in digits.reversed().enumerated() {
            i += abs(digit) * Int(pow(10.0, Double(power)))
        }
        self = i
    }
    
    init?(_ character: Character) {
        guard character.isNumber && character.isASCII else { return nil }
        switch character {
            case "0": self = 0
            case "1": self = 1
            case "2": self = 2
            case "3": self = 3
            case "4": self = 4
            case "5": self = 5
            case "6": self = 6
            case "7": self = 7
            case "8": self = 8
            case "9": self = 9
            default: return nil
        }
    }
    
    enum Direction {
        case up
        case down
    }
    func dividedBy(_ quotient: Int, rounding: Direction) -> Int {
        if rounding == .down { return self / quotient }
        let d = Double(self)
        let q = Double(quotient)
        let div = ceil(d / q)
        return Int(div)
    }
}

public func lcm<I: FixedWidthInteger>(_ values: I ...) -> I {
    return lcm(of: values)
}

public func lcm<C: Collection>(of values: C) -> C.Element where C.Element: FixedWidthInteger {
    let v = values.first!
    let r = values.dropFirst()
    if r.isEmpty { return v }
    
    let lcmR = lcm(of: r)
    return v / gcd(v, lcmR) * lcmR
}

public func gcd<I: FixedWidthInteger>(_ m: I, _ n: I) -> I {
    var a: I = 0
    var b: I = max(m, n)
    var r: I = min(m, n)
    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

public func triangular(_ number: Int) -> Int {
    return (number * (number + 1)) / 2
}
