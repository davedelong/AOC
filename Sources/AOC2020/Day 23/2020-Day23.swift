//
//  Day23.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day23: Day {
    
    static var rawInput: String? { "598162734" }

    func part1() async throws -> String {
//        let input = Input("389125467")
        let list = LinkedList<Int>(input().characters.integers)
        
        for _ in 0 ..< 100 {
            let a = list.remove(at: 1)
            let b = list.remove(at: 1)
            let c = list.remove(at: 1)
            
            var search = list.first! - 1
            var indexOfFound = 0
            while true {
                if let i = list.firstIndex(where: { $0 == search }) {
                    indexOfFound = i
                    break
                } else {
                    search -= 1
                    if search < 0 { search = 9 }
                }
            }
            list.insert(a, at: indexOfFound + 1)
            list.insert(b, at: indexOfFound + 2)
            list.insert(c, at: indexOfFound + 3)
            
            list.append(list.popFirst()!)
        }
        
        while list.first != 1 {
            list.append(list.popFirst()!)
        }
        
        let order = list.map { "\($0)" }.joined().dropFirst()
        
        return "\(order)"
    }

    func part2() async throws -> String {
//        let input = Input("389125467")
        let ints = input().characters.integers
        let first = CircularList_Old.Node(ints[0])
        
        var next = first
        var nodes = [first.value: first]
        for int in ints.dropFirst() {
            next = next.insert(after: int)
            nodes[int] = next
        }
        
        for int in (ints.count+1) ... 1_000_000 {
            next = next.insert(after: int)
            nodes[int] = next
        }
        
        var cup = first
        for _ in 0 ..< 10_000_000 {
            let a = cup.removeAfter()
            let b = cup.removeAfter()
            let c = cup.removeAfter()
            
            var search = cup.value
            let invalid = [cup.value, a, b, c]
            repeat {
                search -= 1
                if search < 1 { search = 1_000_000 }
            } while invalid.contains(search)
            
            var destination = nodes[search]!
            destination = destination.insert(after: a)
            nodes[a] = destination
            destination = destination.insert(after: b)
            nodes[b] = destination
            destination = destination.insert(after: c)
            nodes[c] = destination
            
            cup = cup.cw()
        }
        
        let one = nodes[1]!
        let a = one.cw()
        let b = a.cw()
        return "\(a.value * b.value)"
    }

}
