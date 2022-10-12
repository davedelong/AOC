//
//  Day16.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

class Day16: Day {
    struct Packet {
        let version: Int
        let typeID: Int
        var value: Int = 0
        var subPackets: Array<Packet> = []
        
        var versionSum: Int {
            version + subPackets.sum(of: \.versionSum)
        }
        
        var evaluate: Int {
            switch typeID {
                case 0: return subPackets.sum(of: \.evaluate)
                case 1: return subPackets.product(of: \.evaluate)
                case 2: return subPackets.min(of: \.evaluate)
                case 3: return subPackets.max(of: \.evaluate)
                case 4: return value
                case 5: return subPackets[0].evaluate > subPackets[1].evaluate ? 1 : 0
                case 6: return subPackets[0].evaluate < subPackets[1].evaluate ? 1 : 0
                case 7: return subPackets[0].evaluate == subPackets[1].evaluate ? 1 : 0
                default: fatalError()
            }
        }
        
        var description: String { return description(0).joined(separator: "\n") }
        
        private func description(_ level: Int) -> Array<String> {
            let indent = String(repeating: "  ", count: level)
            var lines = Array<String>()
            lines.append(indent + "Version: \(version)")
            lines.append(indent + "Type: \(typeID)")
            if typeID == 4 {
                lines.append(indent + "Value: \(value)")
            } else {
                for subPacket in subPackets {
                    lines.append(contentsOf: subPacket.description(level + 1))
                }
            }
            return lines
        }
    }
    
    lazy var bits = input().characters.flatMap { Int("\($0)", radix: 16)!.bits.suffix(4) }
    
    lazy var rootPacket: Packet = {
        var slice = bits[...]
        return parsePacket(stream: &slice)
    }()
    
    private func parsePacket(stream: inout ArraySlice<Bit>) -> Packet {
        let version = stream.popFirst(3)
        let type = stream.popFirst(3)
        var p = Packet(version: Int(bits: version), typeID: Int(bits: type))
        
        if p.typeID == 4 {
            var bits = Array<Bit>()
            var keepGoing = true
            while keepGoing {
                let nextChunk = stream.popFirst(5)
                bits.append(contentsOf: nextChunk.suffix(4))
                keepGoing = nextChunk[0] == true
            }
            p.value = Int(bits: bits)
        } else {
            let mode = stream.popFirst()
            if mode {
                let bits = stream.popFirst(11)
                let numberOfSubpackets = Int(bits: bits)
                for _ in 0 ..< numberOfSubpackets {
                    p.subPackets.append(parsePacket(stream: &stream))
                }
            } else {
                let bits = stream.popFirst(15)
                let numberOfBits = Int(bits: bits)
                var parsedBits = 0
                while parsedBits < numberOfBits {
                    let startCount = stream.count
                    let sub = parsePacket(stream: &stream)
                    let endCount = stream.count
                    parsedBits += (startCount - endCount)
                    p.subPackets.append(sub)
                }
            }
        }
        return p
    }
    
    
    func part1() async throws -> Int {
        return rootPacket.versionSum
    }

    func part2() async throws -> Int {
        return rootPacket.evaluate
    }

}
