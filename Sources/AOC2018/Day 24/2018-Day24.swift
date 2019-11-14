//
//  Day24.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

class Day24: Day {
    
    @objc init() { super.init(inputFile: #file) }
    
    let wantsLogging = false
    
    enum Stalemate: Error {
        case stalemate
    }
    
    struct Group: Hashable {
        enum Kind {
            case immuneSystem
            case infection
        }
        enum Attack: String, CaseIterable {
            static let regex: Regex = {
                let values = allCases.map { $0.rawValue }
                let raw = values.joined(separator: "|")
                return Regex(pattern: "(" + raw + ")")
            }()
            case slashing
            case bludgeoning
            case cold
            case radiation
            case fire
        }
        var identifier: Int { return initiative }
        let order: Int
        let kind: Kind
        let units: Int
        let hitPoints: Int
        var effectivePower: Int { return units * attackDamage }
        
        let immunities: Set<Attack>
        let weaknesses: Set<Attack>
        
        let attackDamage: Int
        let attack: Attack
        let initiative: Int
        
        func boost(by power: Int) -> Group {
            return Group(order: order, kind: kind, units: units, hitPoints: hitPoints, immunities: immunities, weaknesses: weaknesses, attackDamage: attackDamage + power, attack: attack, initiative: initiative)
        }
        
        func damageToDeal(_ target: Group) -> Int {
            // if the defending group is immune to the attacking group's attack type, the defending group instead takes no damage;
            if target.immunities.contains(attack) { return 0 }
            
            // By default, an attacking group would deal damage equal to its effective power to the defending group
            var damage = effectivePower
            
            if target.weaknesses.contains(attack) {
                // if the defending group is weak to the attacking group's attack type, the defending group instead takes double damage.
                damage *= 2
            }
            return damage
        }
        
        func acceptDamage(_ damage: Int) -> Group? {
            // The defending group only loses whole units from damage;
            // damage is always dealt in such a way that it kills the most units possible,
            // and any remaining damage to a unit that does not immediately kill it is ignored.
            let unitsKilled = damage / hitPoints
            
            assert(unitsKilled * hitPoints <= damage)
            let unitsRemaining = units - unitsKilled
            if unitsRemaining <= 0 { return nil }
            
            return Group(order: order, kind: kind, units: unitsRemaining, hitPoints: hitPoints, immunities: immunities, weaknesses: weaknesses, attackDamage: attackDamage, attack: attack, initiative: initiative)
        }
    }
    
    lazy var groups: Array<Group> = {
        var groups = Array<Group>()
        
        var currentKind = Group.Kind.immuneSystem
        var currentOrder = 1
        
        let r = Regex(pattern: "(\\d+) units each with (\\d+) hit points( \\((.+?)\\))? with an attack that does (\\d+) (.+?) damage at initiative (\\d+)")
        
        for line in input.lines.raw {
            if line == "Immune System:" {
                currentKind = .immuneSystem
                currentOrder = groups.count { $0.kind == currentKind } + 1
            } else if line == "Infection:" {
                currentKind = .infection
                currentOrder = groups.count { $0.kind == currentKind } + 1
            }
            
            guard let m = r.match(line) else { continue }
            var weak = Set<Group.Attack>()
            var immune = Set<Group.Attack>()
            if let vulnerabilities = m[4] {
                let pieces = vulnerabilities.components(separatedBy: "; ")
                for piece in pieces {
                    let attacks = Group.Attack.regex.matches(in: piece).map { Group.Attack(rawValue: $0[1]!)! }
                    if piece.starts(with: "immune") {
                        immune.formUnion(attacks)
                    } else {
                        weak.formUnion(attacks)
                    }
                }
            }
            
            let units = m.int(1)!
            let hp = m.int(2)!
            let dmg = m.int(5)!
            let attack = Group.Attack(rawValue: m[6]!)!
            let initiative = m.int(7)!
            
            let group = Group(order: currentOrder, kind: currentKind, units: units, hitPoints: hp, immunities: immune, weaknesses: weak, attackDamage: dmg, attack: attack, initiative: initiative)
            groups.append(group)
            currentOrder += 1
        }
        
        return groups
    }()
    
    func runRound(_ input: Array<Group>) throws -> Array<Group> {
        
        if wantsLogging { print("==========================") }
        
        // ready
        if wantsLogging {
            print("Immune System:")
            let immune = input.filter { $0.kind == .immuneSystem }
            immune.forEach { group in
                print("Group \(group.identifier) has \(group.units) units")
            }
            print("Infection:")
            let infection = input.filter { $0.kind == .infection }
            infection.forEach { group in
                print("Group \(group.identifier) has \(group.units) units")
            }
            
            print("")
        }
            
        var currentGroups = input.keyedBy { $0.identifier }
        var targetableGroups = Set(input.map { $0.identifier })
        
        var groupTargets = Array<(Int, Int)>()
        
        // In decreasing order of effective power, groups choose their targets; in a tie, the group with the higher initiative chooses first.
        let groupOrder = input.sorted { (l, r) in
            if l.effectivePower > r.effectivePower { return true }
            if l.effectivePower < r.effectivePower { return false }
            return l.initiative > r.initiative
        }.map { $0.identifier }
        
        // aim
        for groupIdentifier in groupOrder {
            guard let group = currentGroups[groupIdentifier] else { continue }
            
            // The attacking group chooses to target the group in the enemy army to which it would deal the most damage
            // (after accounting for weaknesses and immunities, but not accounting for whether the defending group has enough units to actually receive all of that damage).
            let potentialTargets = currentGroups.values.filter { $0.kind != group.kind && targetableGroups.contains($0.identifier) && group.damageToDeal($0) > 0 }
            
            // If an attacking group is considering two defending groups to which it would deal equal damage,
            // it chooses to target the defending group with the largest effective power;
            // if there is still a tie, it chooses the defending group with the highest initiative.
            let targets = potentialTargets.sorted { (t1, t2) -> Bool in
                let t1Damage = group.damageToDeal(t1)
                let t2Damage = group.damageToDeal(t2)
                if t1Damage > t2Damage { return true }
                if t1Damage < t2Damage { return false }
                if t1.effectivePower > t2.effectivePower { return true }
                if t1.effectivePower < t2.effectivePower { return false }
                return t1.initiative > t2.initiative
            }
            if wantsLogging {
                for target in targets {
                    let damage = group.damageToDeal(target)
                    if damage > 0 {
                        print("\(group.kind) group \(group.identifier) would deal defending group \(target.identifier) \(damage) damage")
                    }
                }
            }
            
            if let target = targets.first {
                groupTargets.append((group.identifier, target.identifier))
                // Defending groups can only be chosen as a target by one attacking group.
                targetableGroups.remove(target.identifier)
            } else {
                // If it cannot deal any defending groups damage, it does not choose a target.
            }
        }
        
        if wantsLogging { print("") }
        
        // Groups attack in decreasing order of initiative, regardless of whether they are part of the infection or the immune system.
        groupTargets = groupTargets.sorted { l, r in
            return l.0 > r.0
        }
        
        // fire
        
        var attacks = 0
        for (groupIdentifier, targetIdentifier) in groupTargets {
            guard let group = currentGroups[groupIdentifier] else {
                // (If a group contains no units, it cannot attack.)
                if wantsLogging { print("group @ \(groupIdentifier) is dead and cannot attack") }
                continue
            }
            guard let target = currentGroups[targetIdentifier] else { continue }
            
            let damage = group.damageToDeal(target)
            let killed: Int
            
            if let damaged = target.acceptDamage(damage) {
                killed = target.units - damaged.units
                currentGroups[targetIdentifier] = damaged
            } else {
                killed = target.units
                currentGroups[targetIdentifier] = nil
            }
            
            if killed > 0 { attacks += 1 }
            if wantsLogging { print("\(group.kind) group \(group.identifier) attacks \(target.kind) group \(target.identifier), killing \(killed) units by dealing \(damage) damage") }
        }
        if attacks == 0 {
            throw Stalemate.stalemate
        }
        return Array(currentGroups.values)
    }
    
    func isOver(_ groups: Array<Group>) -> Bool {
        let infections = groups.count { $0.kind == .infection }
        let isOver = infections == 0 || infections == groups.count
        return isOver
    }
    
    func runSystem(_ boost: Int = 0) -> (Group.Kind, Int)? {
        var currentGroups = groups.map { $0.boost(by: $0.kind == .immuneSystem ? boost : 0) }
        var rounds = 0
        do {
            while isOver(currentGroups) == false {
                currentGroups = try runRound(currentGroups)
                rounds += 1
            }
        } catch {
            return nil
        }
        let kind = currentGroups[0].kind
        let units = currentGroups.map { $0.units }.sum()
        return (kind, units)
    }
    
    override func part1() -> String {
        let (_, remainingUnits) = runSystem()!
        return "\(remainingUnits)"
    }
    
    override func part2() -> String {
        var boost = 1
        while true {
            if let (winner, remaining) = runSystem(boost) {
                if winner == .immuneSystem { return "\(remaining)" }
            }
            boost += 1
        }
        fatalError("unreachable")
    }
    
}
