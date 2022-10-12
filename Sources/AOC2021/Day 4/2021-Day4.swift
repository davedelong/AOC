//
//  Day4.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import AOCCore

typealias Bingo = Matrix<Int>

class Day4: Day {
    
    lazy var numbers: Array<Int> = {
        input().lines[0].integers
    }()
    
    lazy var boards: Array<Bingo> = {
        let lines = input().lines.dropFirst().chunks(of: 6)
        return lines.map { lines in
            let boardLines = lines.dropFirst()
            let ints = boardLines.map(\.integers)
            return Matrix(ints)
        }
    }()

    func part1() async throws -> Int {
        let b = boards.map { $0.copy() }
        
        for n in numbers {
            for board in b {
                if let p = board.position(of: n) {
                    board[p] = -1
                }
                if board.hasBingo() {
                    board.replaceAll(-1, with: 0)
                    let sum = board.data.map(\.sum).sum
                    let final = sum * n
                    return final
                }
            }
        }
        fatalError()
    }

    func part2() async throws -> Int {
        var longestGame = 0
        var lastBoardScore = 0
        
        for board in boards {
            var turns = 0
            for n in numbers where board.hasBingo() == false {
                if let p = board.position(of: n) {
                    board[p] = -1
                }
                turns += 1
                
                if board.hasBingo() && turns > longestGame {
                    board.replaceAll(-1, with: 0)
                    let sum = board.data.map(\.sum).sum
                    
                    longestGame = turns
                    lastBoardScore = sum * n
                    break
                }
            }
        }
        
        return lastBoardScore
    }

}
