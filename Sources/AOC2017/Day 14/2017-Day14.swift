//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/13/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day14: Day {

    let day14Input = "jxqlasbh"
    var disk = Array<Array<Bool>>()
    
    @objc init() { super.init() }

    func knotHash(_ lengthsInput: String) -> String {
        var list = Array(0..<256)
        let lengths = lengthsInput.unicodeScalars.map { Int($0.value) } + [17, 31, 73, 47, 23]
        var skip = 0
        var pos = 0
        
        for _ in 0 ..< 64 {
            for length in lengths {
                let sliceEnd = pos + length
                let end = min(list.count, sliceEnd)
                let wrap = (sliceEnd >= list.count) ? sliceEnd % list.count : 0
                let slice = list[pos ..< end] + list[0 ..< wrap]
                for (offset, i) in slice.reversed().enumerated() { list[(pos + offset) % list.count] = i }
                pos = (pos + length + skip) % list.count
                skip += 1
            }
        }
        
        let hashPieces = (0..<16).map { list[$0 * 16 ..< ($0 + 1) * 16].reduce(0, ^) }
        return hashPieces.map { String(format:"%02x", $0) }.reduce("", +)
    }

    override func part1() -> String {
        for i in 0 ..< 128 {
            let input = "\(day14Input)-\(i)"
            let hash = knotHash(input)
            let row = hash.flatMap { c -> Array<Bool> in
                let int = Int(String(c), radix: 16)!
                var bin = String(int, radix: 2)
                while bin.count < 4 { bin = "0" + bin }
                return bin.map { $0 == "1" ? true : false }
            }
            disk.append(row)
        }
        
        var used = 0
        for r in disk {
            used += r.reduce(0, { $0 + ($1 ? 1 : 0)})
        }
        return "\(used)"
    }
        
    override func part2() -> String {
        var unvisited = Array<Position>()
        for r in 0 ..< 128 {
            for c in 0 ..< 128 {
                unvisited.append(Position(x: c, y: r))
            }
        }


        var regions = Array<Set<Position>>()
        var visited = Set<Position>()

        var currentRegion = Set<Position>()
        while let next = unvisited.popLast() {
            guard visited.contains(next) == false else { continue }
            guard disk[next] != nil else { continue }
            
            var regionStack = [next]
            
            while let candidate = regionStack.popLast() {
                visited.insert(candidate)
                
                if disk[candidate] == true {
                    currentRegion.insert(candidate)
                    let unconsidered = candidate.neighbors().filter { visited.contains($0) == false && disk[$0] != nil }
                    regionStack.append(contentsOf: unconsidered)
                }
            }
            
            if currentRegion.isEmpty == false {
                regions.append(currentRegion)
                currentRegion = []
            }
        }

        return "\(regions.count)"
    }

}
