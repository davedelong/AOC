//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/21/17.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

class Day22: Day {
    
    struct Player {
        var hitPoints: Int
        var mana: Int
        var armor: Int
        var shieldTime: Int
        var rechargeTime: Int
    }
    
    struct Boss {
        var hitPoints: Int
        let damage: Int
        var poisonTime: Int
    }
    
    struct Turn {
        var player: Player
        var boss: Boss
        var playersTurn: Bool
    }
    
    typealias Turns = Array<Turn>
    
    init() { super.init(inputFile: #file) }
    
    private func determinePossibleTurns(from turns: Turns) -> Array<Turns> {
        
        let current = turns.last!
        var next = current
        next.playersTurn.toggle()
        
        // apply timed effects
        if next.player.rechargeTime > 0 { next.player.mana += 101 }
        if next.boss.poisonTime > 0 { next.boss.hitPoints -= 3 }
        
        // decrement timers
        next.player.shieldTime = max(next.player.shieldTime - 1, 0)
        next.player.rechargeTime = max(next.player.rechargeTime - 1, 0)
        next.boss.poisonTime = max(next.boss.poisonTime - 1, 0)
        if current.player.shieldTime == 0 { next.player.armor = 0 }
        
        // if the boss is dead, game over
        if next.boss.hitPoints <= 0 {
            return [turns + [next]]
        }
        
        if current.playersTurn == true {
            // player attacks
            var outcomes = Array<Turns>()
            
            if next.player.mana >= 53 {
                var magicMissile = next
                magicMissile.player.mana -= 53
                magicMissile.boss.hitPoints -= 4
                outcomes.append(turns + [magicMissile])
            }
            
            if next.player.mana >= 73 {
                var drain = next
                drain.player.mana -= 73
                drain.boss.hitPoints -= 2
                drain.player.hitPoints += 2
                outcomes.append(turns + [drain])
            }
            
            if next.player.mana >= 113 && next.player.shieldTime == 0 {
                var shield = next
                shield.player.mana -= 113
                shield.player.shieldTime = 6
                outcomes.append(turns + [shield])
            }
            
            if next.player.mana >= 173 && next.boss.poisonTime == 0 {
                var poison = next
                poison.player.mana -= 173
                poison.boss.poisonTime = 6
                outcomes.append(turns + [poison])
            }
            
            if next.player.mana >= 229 && next.player.rechargeTime == 0 {
                var recharge = next
                recharge.player.mana -= 229
                recharge.player.shieldTime = 5
                recharge.player.armor = 7
                outcomes.append(turns + [recharge])
            }
            
            if outcomes.isEmpty {
                outcomes.append(turns + [next])
            }
            
            return outcomes
        } else {
            // boss attacks
            let attackValue = max(current.boss.damage - current.player.armor, 1)
            next.player.hitPoints -= attackValue
            
            return [turns + [next]]
        }
        
    }
    
    private func manaCost(_ turns: Turns) -> Int {
        var cost = 0
        var previousMana = turns[0].player.mana
        for turn in turns.dropFirst() {
            let manaSpent = previousMana - turn.player.mana
            if manaSpent > 0 {
                cost += manaSpent
            }
            previousMana = turn.player.mana
        }
        return cost
    }
    
    private func runGame(_ initial: Turn) -> Array<Turns> {
        
        var gameplays = [[initial]]
        
        var madeChanges = false
        repeat {
            madeChanges = false
            var newRoutes = Array<Turns>()
            
            for route in gameplays {
                if route.last!.player.hitPoints <= 0 || route.last!.boss.hitPoints <= 0 {
                    newRoutes.append(route)
                } else {
                    let possibilities = determinePossibleTurns(from: route)
                    newRoutes.append(contentsOf: possibilities)
                    madeChanges = true
                }
            }
            
            gameplays = newRoutes
        } while madeChanges == true
        
        return gameplays
        
    }
    
    override func part1() -> String {
        let initial = Turn(player: Player(hitPoints: 50, mana: 500, armor: 0, shieldTime: 0, rechargeTime: 0),
                           boss: Boss(hitPoints: 58, damage: 9, poisonTime: 0),
                           playersTurn: true)
        
        let games = runGame(initial)
        
        let winningGames = games.filter { $0.last!.player.hitPoints > 0 }
        
        let costOfWinningGames = winningGames.map { manaCost($0) }
        
        let leastCost = costOfWinningGames.min()!
        
        return "\(leastCost)"
    }
    
    override func part2() -> String {
        return #function
    }

}
