//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/20/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day21: Day {
    
/*
Weapons:    Cost  Damage  Armor
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0

Armor:      Cost  Damage  Armor
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5

Rings:      Cost  Damage  Armor
Damage +1    25     1       0
Damage +2    50     2       0
Damage +3   100     3       0
Defense +1   20     0       1
Defense +2   40     0       2
Defense +3   80     0       3

*/
    
    struct Item: Equatable, Hashable {
        let name: String
        let cost: Int
        let damage: Int
        let armor: Int
    }
    
    struct Inventory {
        let weaponItem: Item
        let armorItem: Item?
        let ring1Item: Item?
        let ring2Item: Item?
        
        var cost: Int {
            let w = weaponItem.cost
            let a = armorItem?.cost ?? 0
            let r1 = ring1Item?.cost ?? 0
            let r2 = ring2Item?.cost ?? 0
            return w + a + r1 + r2
        }
        
        var damage: Int {
            let w = weaponItem.damage
            let a = armorItem?.damage ?? 0
            let r1 = ring1Item?.damage ?? 0
            let r2 = ring2Item?.damage ?? 0
            return w + a + r1 + r2
        }
        
        var armor: Int {
            let w = weaponItem.armor
            let a = armorItem?.armor ?? 0
            let r1 = ring1Item?.armor ?? 0
            let r2 = ring2Item?.armor ?? 0
            return w + a + r1 + r2
        }
    }
    
    struct Character {
        var hitPoints: Int
        let damage: Int
        let armor: Int
    }
    
    init() { super.init(inputSource: .none) }
    
    struct InventoryIterator: IteratorProtocol {
        
        private var weaponIndex = 0
        private var armorIndex: Int? = nil
        private var ring1Index: Int? = nil
        private var ring2Index: Int? = nil
        
        let weapons: Array<Item> = [
            Item(name: "Dagger", cost: 8, damage: 4, armor: 0),
            Item(name: "Shortsword", cost: 10, damage: 5, armor: 0),
            Item(name: "Warhammer", cost: 25, damage: 6, armor: 0),
            Item(name: "Longsword", cost: 40, damage: 7, armor: 0),
            Item(name: "Greataxe", cost: 74, damage: 8, armor: 0)
        ]
        
        let armor: Array<Item> = [
            Item(name: "Leather", cost: 13, damage: 0, armor: 1),
            Item(name: "Chainmail", cost: 31, damage: 0, armor: 2),
            Item(name: "Splintmail", cost: 53, damage: 0, armor: 3),
            Item(name: "Bandedmail", cost: 75, damage: 0, armor: 4),
            Item(name: "Platemail", cost: 102, damage: 0, armor: 5)
        ]
        
        let rings: Array<Item> = [
            Item(name: "Damage +1", cost: 25, damage: 1, armor: 0),
            Item(name: "Damage +2", cost: 50, damage: 2, armor: 0),
            Item(name: "Damage +3", cost: 100, damage: 3, armor: 0),
            Item(name: "Defense +1", cost: 20, damage: 0, armor: 1),
            Item(name: "Defense +2", cost: 40, damage: 0, armor: 2),
            Item(name: "Defense +3", cost: 80, damage: 0, armor: 3)
        ]
        
        private mutating func increment() {
            // increment ring2
            var carry = false
            if let r2 = ring2Index {
                ring2Index = r2 + 1
            } else {
                if let r1 = ring1Index {
                    ring2Index = r1 + 1
                } else {
                    ring2Index = 0
                }
            }
            if let r2 = ring2Index, r2 >= rings.count {
                ring2Index = nil
                carry = true
            }
            guard carry == true else { return }
            
            carry = false
            if let r1 = ring1Index {
                ring1Index = r1 + 1
            } else {
                ring1Index = 0
            }
            if let r1 = ring1Index, r1 >= rings.count {
                ring1Index = nil
                carry = true
            }
            guard carry == true else { return }
            
            carry = false
            if let a = armorIndex {
                armorIndex = a + 1
            } else {
                armorIndex = 0
            }
            if let a = armorIndex, a >= armor.count {
                armorIndex = nil
                carry = true
            }
            guard carry == true else { return }
            weaponIndex += 1
        }
        
        mutating func next() -> Inventory? {
            if weaponIndex >= weapons.count { return nil }
            
            let w = weapons[weaponIndex]
            let a = armorIndex.map { armor[$0] }
            let r1 = ring1Index.map { rings[$0] }
            let r2 = ring2Index.map { rings[$0] }
            let i = Inventory(weaponItem: w, armorItem: a, ring1Item: r1, ring2Item: r2)
            
            increment()
            
            return i
        }
        
    }
    
    // return true if the player beats the boss
    private func runScenario(_ inventory: Inventory) -> Bool {
        var players = [
            Character(hitPoints: 100, damage: inventory.damage, armor: inventory.armor),
            Character(hitPoints: 109, damage: 8, armor: 2)
        ]
        var currentPlayer = 0
        var otherPlayer = 1
        while true {
            let damageDealt = max(players[currentPlayer].damage - players[otherPlayer].armor, 1)
            players[otherPlayer].hitPoints -= damageDealt
            
            if players[otherPlayer].hitPoints <= 0 {
                return currentPlayer == 0
            }
            
            swap(&currentPlayer, &otherPlayer)
        }
    }
    
    override func part1() -> String {
        var inventories = InventoryIterator()
        
        var minCost = Int.max
        while let i = inventories.next() {
            if runScenario(i) {
                minCost = min(minCost, i.cost)
            }
        }
        
        return "\(minCost)"
    }
    
    override func part2() -> String {
        var inventories = InventoryIterator()
        
        var maxCost = 0
        while let i = inventories.next() {
            if runScenario(i) == false {
                maxCost = max(maxCost, i.cost)
            }
        }
        
        return "\(maxCost)"
    }

}
