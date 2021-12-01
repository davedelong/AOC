//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/13/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day13: Day {
    
    typealias Path = Array<String>
    typealias Rule = (String, String, Int)
    
    lazy var rules: Array<Rule> = {
        let r = Regex(#"(.+?) would (gain|lose) (\d+) happiness units by sitting next to (.+?)\."#)
        return input.lines.raw.map { l in
            let m = r.firstMatch(in: l)!
            let person1 = m[1]!
            let multiplier = m[2] == "gain" ? 1 : -1
            let points = m.int(3)!
            let person2 = m[4]!
            
            return (person1, person2, points * multiplier)
        }
    }()
    
    private func buildPaths(parent: Path, people: Set<String>) -> Array<Path> {
        let remainingPeople = people.subtracting(parent)
        guard remainingPeople.isNotEmpty else { return [parent] }
        
        let paths = remainingPeople.flatMap { c -> Array<Path> in
            return buildPaths(parent: parent + [c], people: people)
        }
        
        return paths
    }
    
    private func arrangementCost(_ people: Path, rules: Array<Rule>) -> Int {
        var cost = 0
        for i in 1 ..< people.count {
            let p1 = people[i-1]
            let p2 = people[i]
            
            let r1 = rules.first { $0.0 == p1 && $0.1 == p2 }!
            let r2 = rules.first { $0.0 == p2 && $0.1 == p1 }!
            cost += r1.2
            cost += r2.2
        }
        
        let r1 = rules.first { $0.0 == people.last! && $0.1 == people.first! }!
        let r2 = rules.first { $0.0 == people.first! && $0.1 == people.last! }!
        cost += r1.2
        cost += r2.2
        return cost
    }
    
    override func part1() -> String {
        let allPeople = Set(rules.flatMap { [$0.0, $0.1] })
        
        let allArrangements = allPeople.flatMap {
            buildPaths(parent: [$0], people: allPeople)
        }
        
        let pathsAndCosts = allArrangements.map { ($0, arrangementCost($0, rules: rules)) }
        let mostHappyFirst = pathsAndCosts.sorted { $0.1 > $1.1 }
        
        return "\(mostHappyFirst[0].1)"
    }
    
    override func part2() -> String {
        var rulesWithMe = rules
        var allPeople = Set(rulesWithMe.flatMap { [$0.0, $0.1] })
        for p in allPeople {
            rulesWithMe.append(("me", p, 0))
            rulesWithMe.append((p, "me", 0))
        }
        allPeople.insert("me")
        
        let allArrangements = allPeople.flatMap {
            buildPaths(parent: [$0], people: allPeople)
        }
        
        let pathsAndCosts = allArrangements.map { ($0, arrangementCost($0, rules: rulesWithMe)) }
        let mostHappyFirst = pathsAndCosts.sorted { $0.1 > $1.1 }
        
        return "\(mostHappyFirst[0].1)"
    }
    
}
