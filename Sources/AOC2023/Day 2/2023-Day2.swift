//
//  Day2.swift
//  AOC2023
//
//  Created by Dave DeLong on 11/30/23.
//  Copyright © 2023 Dave DeLong. All rights reserved.
//

class Day2: Day {
    typealias Part1 = Int
    typealias Part2 = Int
    
    static var rawInput: String? { nil }
    
    
    lazy var games: Array<Game> = {
        let gameID = /^Game (\d+):/
        let color = /(\d+) (red|green|blue)/
        
        return input().lines.raw.compactMap { line -> Game? in
            guard let id = line.firstMatch(of: gameID)?.1.int else { return nil }
            let rawRounds = line.split(separator: ":")[1]
            
            let rounds = rawRounds.split(separator: ";").map { round -> CountedSet<String> in
                var f = CountedSet<String>()
                for match in try! color.allMatches(in: round) {
                    let value = match.1.int!
                    let color = String(match.2)
                    f.insert(color, times: value)
                }
                return f
            }
            return Game(id: id, rounds: rounds)
        }
    }()

    func run() async throws -> (Part1, Part2) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

    func part1() async throws -> Part1 {
        var expected = CountedSet<String>()
        expected.insert("red", times: 12)
        expected.insert("green", times: 13)
        expected.insert("blue", times: 14)
        
        let validGames = games.filter { game in
            game.rounds.allSatisfy({ round in
                round.isSubset(of: expected)
            })
        }
        
        return validGames.sum(of: \.id)!
    }

    func part2() async throws -> Part2 {
        
        let powers = games.map { game in
            var red = 0
            var green = 0
            var blue = 0
            
            for round in game.rounds {
                red = max(red, round.count(for: "red"))
                green = max(green, round.count(for: "green"))
                blue = max(blue, round.count(for: "blue"))
            }
            
            return red * green * blue
        }
        
        return powers.sum!
    }

}

struct Game {
    let id: Int
    let rounds: Array<CountedSet<String>>
}
