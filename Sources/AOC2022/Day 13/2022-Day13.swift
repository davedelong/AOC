//
//  Day13.swift
//  AOC2022
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

class Day13: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    private func parsePacket(_ line: String) -> Packet? {
        var s = Scanner(data: line)
        return parsePacket(&s)
    }
    
    private func parsePacket(_ line: inout Scanner<String>) -> Packet? {
        if line.tryScan("[") {
            var list = Array<Packet>()
            while let packet = parsePacket(&line) {
                list.append(packet)
                line.tryScan(",")
            }
            line.scan("]")
            return .list(list)
        } else if let int = line.tryScanInt() {
            return .integer(int)
        } else {
            return nil
        }
    }
    
    private lazy var packets: Array<Packet> = {
        input().lines.filter(\.isNotEmpty).compactMap { parsePacket($0.raw) }
    }()

    func part1() async throws -> Part1 {
        return packets.pairs().enumerated().sum(of: { (i, p) in
            return p.0 < p.1 ? i + 1 : 0
        })
    }

    func part2() async throws -> Part2 {
        let d1 = parsePacket("[[2]]")!
        let d2 = parsePacket("[[6]]")!
        
        let withDividers = packets + [d1, d2]
        
        let sorted = withDividers.sorted(by: <)
        
        let d1Index = sorted.firstIndex(of: d1)!
        let d2Index = sorted.firstIndex(of: d2)!
        
        return (d1Index + 1) * (d2Index + 1)
    }

}


fileprivate enum Packet: CustomStringConvertible, Comparable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool { return compare(left: lhs, right: rhs) == .orderedSame }
    public static func < (lhs: Self, rhs: Self) -> Bool { return compare(left: lhs, right: rhs) == .orderedAscending }
    public static func > (lhs: Self, rhs: Self) -> Bool { return compare(left: lhs, right: rhs) == .orderedDescending }
    
    private static func compare(left: Packet, right: Packet) -> ComparisonResult {
        switch (left, right) {
            case (.integer(let l), .integer(let r)):
                return l.compare(r)
                
            case (.list(let l), .list(let r)):
                
                for (lPacket, rPacket) in zip(l, r) {
                    let c = compare(left: lPacket, right: rPacket)
                    if c != .orderedSame { return c }
                }
                // if we get here, they're all the same; see if one ran out
                if l.count < r.count { return .orderedAscending }
                if l.count > r.count { return .orderedDescending }
                return .orderedSame
                
            case (.integer, .list(let r)):
                return compare(left: .list([left]), right: .list(r))
                
            case (.list(let l), .integer):
                return compare(left: .list(l), right: .list([right]))
        }
    }
    
    
    case integer(Int)
    case list(Array<Packet>)
    
    var description: String {
        switch self {
            case .integer(let i): return i.description
            case .list(let l): return "[" + l.map(\.description).joined(separator: ",") + "]"
        }
    }
}
