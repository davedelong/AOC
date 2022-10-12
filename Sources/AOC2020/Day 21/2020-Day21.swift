//
//  Day21.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

class Day21: Day {

    func run() async throws -> (Int, String) {
        var ingredientCounts = CountedSet<String>()
        var allergenTable = Dictionary<String, Set<String>>()
        
        for line in input().lines.raw {
            let parts = line.split(on: "(contains ")
            let ingredients = parts[0].split(on: \.isWhitespace).map(String.init).filter(\.isNotEmpty)
            let allergens = Set(parts[1].dropLast().split(on: ", ").map(String.init).filter(\.isNotEmpty))
            
            for a in allergens {
                if let existing = allergenTable[a] {
                    let narrowed = existing.intersection(ingredients)
                    if narrowed.count == 1 {
                        for key in allergenTable.keys {
                            allergenTable[key]?.remove(narrowed.first!)
                        }
                    }
                    allergenTable[a] = narrowed
                } else {
                    allergenTable[a] = Set(ingredients)
                }
            }
            
            for i in ingredients {
                ingredientCounts[i, default: 0] += 1
            }
        }
        
        let possibleAllergenicIngredients = allergenTable.values.flatMap({ $0 })
        
        for p in possibleAllergenicIngredients {
            ingredientCounts[p] = 0
        }
        let p1 = ingredientCounts.values.sum
        
        while allergenTable.values.contains(where: { $0.count > 1 }) {
            for (ingredient, value) in allergenTable {
                if value.count == 1 {
                    for key in allergenTable.keys {
                        if key == ingredient { continue }
                        allergenTable[key]?.remove(value.first!)
                    }
                }
            }
        }
        
        let sortedKeys = allergenTable.keys.sorted()
        let ingredients = sortedKeys.compactMap { allergenTable[$0]?.first }
        let p2 = ingredients.joined(separator: ",")
        
        return (p1, p2)
    }

}
