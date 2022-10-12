//
//  Day18.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

class Day18: Day {
    
    let useOriginalApproach = true
    
    func part1() async throws -> String {
        if useOriginalApproach {
            return approach1_part1()
        } else {
            return approach1_part2()
        }
    }
    
    func part2() async throws -> String {
        if useOriginalApproach {
            return approach2_part1()
        } else {
            return approach2_part2()
        }
    }
    
    enum RidiculousFish: Equatable {
        case pairOpen
        case number(Int)
        case pairClose
        
        var isNumber: Bool {
            guard case .number = self else { return false }
            return true
        }
    }
    
    var parseInput: Array<LinkedList<RidiculousFish>> {
        return input().lines.raw.map { line -> LinkedList<RidiculousFish> in
            let l = LinkedList<RidiculousFish>()
            for char in line {
                switch char {
                    case "[": l.append(.pairOpen)
                    case "]": l.append(.pairClose)
                    default:
                        if let v = Int(char) { l.append(.number(v)) }
                }
            }
            return l
        }
    }
    
    func approach2_part1() -> String {
        let parsed = self.parseInput
        let result = parsed[0]
        print(describe(result))
        reduce(result)
        
        for next in parsed.dropFirst() {
            add(lhs: result, rhs: next)
            reduce(result)
        }
        print(describe(result))
        return magnitude(of: result).description
    }
    
    func approach2_part2() -> String {
        let parsed = self.parseInput
        
        var m = Int.min
        for pair in parsed.combinations(ofCount: 2) {
            let a = pair[0].copy()
            add(lhs: a, rhs: pair[1])
            reduce(a)
            m = max(m, magnitude(of: a))
            
            let b = pair[1].copy()
            add(lhs: b, rhs: pair[0])
            reduce(b)
            m = max(m, magnitude(of: b))
        }
        
        return m.description
    }
    
    private func add(lhs: LinkedList<RidiculousFish>, rhs: LinkedList<RidiculousFish>) {
        lhs.insert(.pairOpen, at: 0)
        lhs.append(contentsOf: rhs)
        lhs.append(.pairClose)
    }
    
    private func reduce(_ fish: LinkedList<RidiculousFish>) {
        var keepGoing = true
        
        while keepGoing {
            keepGoing = explode(fish)
            if !keepGoing { keepGoing = split(fish) }
        }
    }
    
    private func explode(_ fish: LinkedList<RidiculousFish>) -> Bool {
        var pairCount = 0
        
        var current = fish.head
        while let node = current {
            defer { current = node.next }
            
            switch node.value {
                case .pairOpen:
                    pairCount += 1
                    
                case .pairClose:
                    pairCount -= 1
                    
                case .number(let v):
                    if pairCount > 4 && node.next?.value.isNumber == true {
                        // explodeable pair
                        
                        // search backwards before this node to find another number
                        if let previousNumber = sequence(first: node.prev!, next: \.prev).first(where: \.value.isNumber) {
                            guard case .number(let pV) = previousNumber.value else { fatalError() }
                            previousNumber.value = .number(pV + v)
                        }
                        
                        // search forwards after the second node in this pair to find another number
                        if let nextNumber = sequence(first: node.next!.next!, next: \.next).first(where: \.value.isNumber), case .number(let pairNumber) = node.next?.value {
                            guard case .number(let nV) = nextNumber.value else { fatalError() }
                            nextNumber.value = .number(nV + pairNumber)
                        }
                        
                        // replace this pair with zero
                        let pairPrior = node.prev!.prev!
                        let pairAfter = node.next!.next!.next!
                        while let n = pairPrior.next, n !== pairAfter {
                            fish.delete(n)
                        }
                        fish.insert(.number(0), after: pairPrior)
                        
                        // return immediately that we mutated something
                        return true
                    }
            }
        }
        return false
    }
    
    private func split(_ fish: LinkedList<RidiculousFish>) -> Bool {
        var current = fish.head
        while let node = current {
            if case .number(let v) = node.value, v >= 10 {
                // this value becomes a pair
                node.value = .pairOpen
                let p1 = fish.insert(.number(v/2), after: node)
                
                let v2 = (v.isMultiple(of: 2)) ? (v/2) : (v/2 + 1)
                let p2 = fish.insert(.number(v2), after: p1)
                fish.insert(.pairClose, after: p2)
                
                return true
            }
            current = node.next
        }
        return false
    }
    
    private func magnitude(of fish: LinkedList<RidiculousFish>) -> Int {
        func recurse(_ node: inout LinkedList<RidiculousFish>.Node?) -> Int {
            if case .number(let v) = node?.value {
                node = node?.next
                return v
            } else {
                node = node?.next // openPair
                let left = recurse(&node)
                let right = recurse(&node)
                node = node?.next // closePair
                return (3 * left) + (2 * right)
            }
        }
        
        var h = fish.head
        return recurse(&h)
    }
    
    private func describe(_ fish: LinkedList<RidiculousFish>) -> String {
        var c = Array<String>()
        var current = fish.head
        while let node = current {
            switch node.value {
                case .pairOpen: c.append("[")
                case .pairClose:
                    c.append("]")
                    if node.next?.value != .pairClose { c.append(",") }
                case .number(let v):
                    c.append("\(v)")
                    if node.prev?.value == .pairOpen { c.append(",") }
            }
            current = node.next
        }
        
        return c.joined()
    }
    
    // MARK: initial implementation
    
    var fish: Array<Fish> {
        return input().lines.characters.map { chars -> Fish in
            var slice = chars[...]
            var allFish = Dictionary<Int, Fish>()
            let fish = parseFish(&slice, allFish: &allFish)
            let fishInOrder = allFish.keys.sorted(by: <)
            for (p, n) in fishInOrder.adjacentPairs() {
                let l = allFish[p]!
                let r = allFish[n]!
                l.next = r
                r.previous = l
            }
            return fish
        }
    }
    
    private func parseFish(_ chars: inout ArraySlice<Character>, allFish: inout Dictionary<Int, Fish>) -> Fish {
        let char = chars.popFirst()
        switch char {
            case "[":
                let left = parseFish(&chars, allFish: &allFish)
                assert(chars.popFirst() == ",")
                let right = parseFish(&chars, allFish: &allFish)
                assert(chars.popFirst() == "]")
                let f = Fish()
                f.child1 = left
                f.child2 = right
                return f
            default:
                assert(char.isNumber)
                let value = Int(char)!
                let f = Fish()
                f.value = value
                allFish[chars.startIndex-1] = f
                return f
        }
    }

    func approach1_part1() -> String {
        let parsed = fish
        var result = parsed[0]
        for nextFish in parsed.dropFirst() {
            result = add(lhs: result, rhs: nextFish)
        }
        return result.magnitude.description
    }

    func approach1_part2() -> String {
        let parsed = fish
        
        var m = Int.min
        let choices = parsed.combinations(ofCount: 2)
        for pair in choices {
            let r1 = add(lhs: pair[0], rhs: pair[1])
            m = max(m, r1.magnitude)
            
            let r2 = add(lhs: pair[1], rhs: pair[0])
            m = max(m, r2.magnitude)
        }
        return m.description
    }

    private func add(lhs: Fish, rhs: Fish) -> Fish {
        let l = lhs.deepCopy()
        let r = rhs.deepCopy()
        
        let add = Fish()
        add.child1 = l
        add.child2 = r
        
        let leftBridge = l.lastNumber
        let rightBridge = r.firstNumber
        
        leftBridge?.next = rightBridge
        rightBridge?.previous = leftBridge
        
        add.reduceTotally()
        return add
    }
    
}

class Fish: Hashable {
    static func ==(lhs: Fish, rhs: Fish) -> Bool {
        return lhs === rhs
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    var value: Int?
    var child1: Fish?
    var child2: Fish?
    
    var previous: Fish?
    var next: Fish?
    
    var magnitude: Int {
        if let v = value { return v }
        return (3 * child1!.magnitude) + (2 * child2!.magnitude)
    }
    
    var description: String {
        if let v = value { return "\(v)" }
        return "[\(child1!.description),\(child2!.description)]"
    }
    
    func deepCopy() -> Fish {
        var map = Dictionary<Fish, Fish>()
        let dupe = _deepCopy(map: &map)
        // now we need to lash up the prev/next pointers
        setUpPrevNextPointers(map: map)
        return dupe
    }
    
    private func _deepCopy(map: inout Dictionary<Fish, Fish>) -> Fish {
        let f = Fish()
        map[self] = f
        
        f.value = value
        f.child1 = child1?._deepCopy(map: &map)
        f.child2 = child2?._deepCopy(map: &map)
        return f
    }
    
    private func setUpPrevNextPointers(map: Dictionary<Fish, Fish>) {
        if value != nil {
            // this is a node that has prev/next pointers
            let copyOfSelf = map[self]!
            if let p = previous {
                copyOfSelf.previous = map[p]!
            }
            if let n = next {
                copyOfSelf.next = map[n]
            }
        } else {
            child1?.setUpPrevNextPointers(map: map)
            child2?.setUpPrevNextPointers(map: map)
        }
        
    }
    
    func reduceTotally() {
        var keepGoing = true
        while keepGoing {
            keepGoing = self.reduce(1, canSplit: false)
            if keepGoing == false {
                keepGoing = self.reduce(1, canSplit: true)
            }
        }
    }
    
    var firstNumber: Fish? {
        if value != nil { return self }
        return child1?.firstNumber
    }
    
    var lastNumber: Fish? {
        if value != nil { return self }
        return child2?.lastNumber
    }
    
    // returns true is something changed
    func reduce(_ level: Int = 1, canSplit: Bool) -> Bool {
        if let v = value {
            if v >= 10 && canSplit == true {
                // replace this with a pair
                value = nil
                
                child1 = Fish()
                child2 = Fish()
                
                if v.isMultiple(of: 2) {
                    child1?.value = v/2
                    child2?.value = v/2
                } else {
                    child1?.value = v/2
                    child2?.value = v/2 + 1
                }
                
                child1?.previous = previous
                previous?.next = child1
                previous = nil
                
                child1?.next = child2
                child2?.previous = child1
                
                child2?.next = next
                next?.previous = child2
                next = nil
                return true
            } else {
                return false
            }
        } else {
            // this is a parent node
            if level > 4 && child1?.value != nil && child2?.value != nil {
                // EXPLODE
                
                let previousNumber = child1?.previous
                let nextNumber = child2?.next
                
                // distribute the numbers
                previousNumber?.value! += child1?.value ?? 0
                nextNumber?.value! += child2?.value ?? 0
                
                value = 0
                previousNumber?.next = self
                self.previous = previousNumber
                
                nextNumber?.previous = self
                self.next = nextNumber
                
                child1 = nil
                child2 = nil
                
                return true
            }
            
            if child1?.reduce(level+1, canSplit: canSplit) == true { return true }
            if child2?.reduce(level+1, canSplit: canSplit) == true { return true }
            return false
        }
    }
}
