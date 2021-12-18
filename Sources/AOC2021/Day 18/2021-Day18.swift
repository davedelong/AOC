//
//  Day18.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

class Day18: Day {
    
    var fish: Array<Fish> {
        return input.lines.characters.map { chars -> Fish in
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

    override func part1() -> String {
        let parsed = fish
        var result = parsed[0]
        for nextFish in parsed.dropFirst() {
            result = add(lhs: result, rhs: nextFish)
        }
        return result.magnitude.description
    }

    override func part2() -> String {
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
