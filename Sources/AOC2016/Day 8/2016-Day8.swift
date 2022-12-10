//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/7/17.
//  Copyright © 2016 Dave DeLong. All rights reserved.
//

class Day8: Day {
    
    enum Instruction {
        case rect(PointSpan2)
        case rotateRow(Int, Int)
        case rotateColumn(Int, Int)
    }
    
    lazy var instructions: Array<Instruction> = {
        let rect = Regex(#"rect (\d+)x(\d+)"#)
        let row = Regex(#"rotate row y=(\d+) by (\d+)"#)
        let col = Regex(#"rotate column x=(\d+) by (\d+)"#)
        
        return input().lines.raw.compactMap { r in
            if let m = rect.firstMatch(in: r) {
                return .rect(.init(origin: .zero, width: m[int: 1]!, height: m[int: 2]!))
            } else if let m = row.firstMatch(in: r) {
                return .rotateRow(m[int: 1]!, m[int: 2]!)
            } else if let m = col.firstMatch(in: r) {
                return .rotateColumn(m[int: 1]!, m[int: 2]!)
            } else {
                return nil
            }
        }
    }()
    
    func run() async throws -> (Int, String) {
        let m = Matrix<Bit>(rows: 6, columns: 50, value: .off)
        
        for instruction in instructions {
            switch instruction {
                case .rect(let s):
                    for p in s { m[p] = .on }
                    
                case .rotateRow(let row, let steps):
                    m.rightShiftRow(row, steps: steps)
                    
                case .rotateColumn(let col, let steps):
                    m.downShiftColumn(col, steps: steps)
            }
        }
        
        let p1 = m.count(of: .on)
        let p2 = m.recognizeLetters()
        
        return (p1, p2)
    }

}
