//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/14/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day15: Day {
    
    /*
Sugar: capacity 3, durability 0, flavor 0, texture -3, calories 2
Sprinkles: capacity -3, durability 3, flavor 0, texture 0, calories 9
Candy: capacity -1, durability 0, flavor 4, texture 0, calories 1
Chocolate: capacity 0, durability 0, flavor -2, texture 2, calories 8
*/
    
    struct Ingredient {
        let name: String
        let capacity: Int
        let durability: Int
        let flavor: Int
        let texture: Int
        let calories: Int
        
        func scoreFor(_ amount: Int) -> Int {
            return max((capacity * amount) + (durability * amount) + (flavor * amount) + (texture * amount), 0)
        }
    }
    
    struct RecipeAmounts: IteratorProtocol {
        private let max: Int
        private var latest: Array<Int>?
        private let sentinel: Array<Int>
        init(maximumAmount: Int, partitions: Int) {
            max = maximumAmount
            latest = Array(repeating: 0, count: partitions)
            sentinel = Array(repeating: maximumAmount, count: partitions)
        }
        
        mutating func next() -> Array<Int>? {
            guard let l = latest else { return nil }
            
            var n = l
            repeat {
                var carry = 1
                var column = 0
                while carry > 0 {
                    n[column] += carry
                    carry = 0
                    if n[column] > max {
                        carry += 1
                        n[column] = 0
                    }
                    column += 1
                }
            } while n.sum() != max && n != sentinel
            latest = n == sentinel ? nil : n
            return l
        }
    }
    
    let ingredients = [
        Ingredient(name: "Sugar", capacity: 3, durability: 0, flavor: 0, texture: -3, calories: 2),
        Ingredient(name: "Sprinkles", capacity: -3, durability: 3, flavor: 0, texture: 0, calories: 9),
        Ingredient(name: "Candy", capacity: -1, durability: 0, flavor: 4, texture: 0, calories: 1),
        Ingredient(name: "Chocolate", capacity: 0, durability: 0, flavor: -2, texture: 2, calories: 8)
        
//            Ingredient(name: "Butterscotch", capacity: -1, durability: -2, flavor: 6, texture: 3, calories: 8),
//            Ingredient(name: "Cinnamon", capacity: 2, durability: 3, flavor: -2, texture: -1, calories: 3)
    ]
    
    override func run() -> (String, String) {
        var bestScore = 0
        var bestScoreWith500Calories = 0
        
        var proportions = RecipeAmounts(maximumAmount: 100, partitions: ingredients.count)
        while let p = proportions.next() {
            let pairs = zip(p, ingredients)
            let numbers = [
                max(pairs.map { $0 * $1.capacity }.sum(), 0),
                max(pairs.map { $0 * $1.durability }.sum(), 0),
                max(pairs.map { $0 * $1.flavor }.sum(), 0),
                max(pairs.map { $0 * $1.texture }.sum(), 0)
            ]
            let score = numbers.product()
            if score > bestScore {
                bestScore = score
            }
            
            let calories = pairs.map { $0 * $1.calories }.sum()
            if calories == 500 && score > bestScoreWith500Calories {
                bestScoreWith500Calories = score
            }
        }
        
        return ("\(bestScore)", "\(bestScoreWith500Calories)")
    }
}
