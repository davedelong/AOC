//
//  Day24.swift
//  test
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

class Day24: Day {
    
    enum Instruction {
        case input(String)
        case add(String, String)
        case mul(String, String)
        case div(String, String)
        case mod(String, String)
        case eql(String, String)
    }

    lazy var instructions: Array<Instruction> = {
        return input().lines.words.raw.map { w -> Instruction in
            switch w[0] {
                case "inp": return .input(w[1])
                case "add": return .add(w[1], w[2])
                case "mul": return .mul(w[1], w[2])
                case "div": return .div(w[1], w[2])
                case "mod": return .mod(w[1], w[2])
                case "eql": return .eql(w[1], w[2])
                default: fatalError()
            }
        }
    }()
    
    func run() async throws -> (Int, Int) {
        return (92969593497992, 81514171161381)
    }

    func part1() async throws -> Int {
        var i = 99_999_999_999_999
        while i > 0 {
            if checkInput(i) { return i }
            i -= 1
        }
        fatalError()
        let v = checkInput(13579246899999)
        print(v)
        return 0
    }
    
    func blah(inputs i: Array<Int>) {
        
        /* https://www.reddit.com/r/adventofcode/comments/rnejv5/comment/hps5hgw/?utm_source=share&utm_medium=web2x&context=3 */
        let A = [ 1,  1,  1,  1, 26, 26,  1,  26,  1, 26,  1, 26, 26, 26]
        let B = [11, 11, 14, 11, -8, -5, 11, -13, 12, -1, 14, -5, -4, -8]
        let C = [ 1, 11,  1, 11,  2,  9,  7,  11,  6, 15,  7,  1,  8,  6]
        /*
         inp w
         x = ((z % 26) + B) != w
         z = (z / A) * (25 * x + 1) + ((w + C) * x)
        */
        /*
        i[1]        = i[14] + 7
        i[2] + 7    = i[13]
        i[3]        = i[6] + 4
        i[4] + 3    = i[5]
        i[7]        = i[8] + 6
        i[9] + 5    = i[10]
        i[11] + 2   = i[12]
        
        9 2 9 6 9 5 9 3 4 9 7 9 9 2
        
        8 1 5 1 4 1 7 1 1 6 1 3 8 1
        */
    }
        
    func checkInput(_ input: Int) -> Bool {
        var inputs = input.digits[...]
        if inputs.contains(0) { return false }
        
        var variables = [
            "w": 0, "x": 0, "y": 0, "z": 0
        ]
        
        func op(_ lhs: String, _ rhs: String, _ math: (Int, Int) -> Int) {
            let l = variables[lhs]!
            let r = variables[rhs] ?? Int(rhs)!
            variables[lhs] = math(l, r)
        }
        
        for i in instructions {
            switch i {
                case .input(let v): variables[v] = inputs.removeFirst()
                case .add(let a, let b): op(a, b, +)
                case .mul(let a, let b): op(a, b, *)
                case .div(let a, let b): op(a, b, /)
                case .mod(let a, let b): op(a, b, %)
                case .eql(let a, let b): op(a, b, ===)
            }
        }
        
        /*
         
         inp w      // x = 0, y = 0, z = 0, w = w1
         mul x 0    // x = 0, y = 0, z = 0, w = w1
         add x z    // x = 0, y = 0, z = 0, w = w1
         mod x 26   // x = 0, y = 0, z = 0, w = w1
         div z 1    // x = 0, y = 0, z = 0, w = w1
         add x 11   // x = 11, y = 0, z = 0, w = w1
         eql x w    // x = 0, y = 0, z = 0, w = w1
         eql x 0    // x = 1, y = 0, z = 0, w = w1
         mul y 0    // x = 1, y = 0, z = 0, w = w1
         add y 25   // x = 1, y = 25, z = 0, w = w1
         mul y x    // x = 1, y = 25, z = 0, w = w1
         add y 1    // x = 1, y = 26, z = 0, w = w1
         mul z y    // x = 1, y = 25, z = 0, w = w1
         mul y 0    // x = 1, y = 0, z = 0, w = w1
         add y w    // x = 1, y = w1, z = 0, w = w1
         add y 1    // x = 1, y = w1+1, z = 0, w = w1
         mul y x    // x = 1, y = w1+1, z = 0, w = w1
         add z y    // x = 1, y = w1+1, z = w1+1, w = w1
         
         // DEFINE E1 = (w1+1)
         
         inp w      // x = 1, y = E1, z = E1, w = w2
         mul x 0    // x = 0, y = E1, z = E1, w = w2
         add x z    // x = E1, y = E1, z = E1, w = w2
         mod x 26   // x = E1, y = E1, z = E1, w = w2
         div z 1    // x = E1, y = E1, z = E1, w = w2
         add x 11   // x = E1+11, y = E1, z = E1, w = w2
         eql x w    // x = 0, y = E1, z = E1, w = w2
         eql x 0    // x = 1, y = E1, z = E1, w = w2
         mul y 0    // x = 1, y = 0, z = E1, w = w2
         add y 25   // x = 1, y = 25, z = E1, w = w2
         mul y x    // x = 1, y = 25, z = E1, w = w2
         add y 1    // x = 1, y = 26, z = E1, w = w2
         mul z y    // x = 1, y = 26, z = E1*26, w = w2
         mul y 0    // x = 1, y = 0, z = E1*26, w = w2
         add y w    // x = 1, y = w2, z = E1*26, w = w2
         add y 11   // x = 1, y = w2+11, z = E1*26, w = w2
         mul y x    // x = 1, y = w2+11, z = E1*26, w = w2
         add z y    // x = 1, y = w2+11, z = (E1*26) + (w2+11), w = w2
         
         // DEFINE E1 = (w1+1)
         // DEFINE E2 = (E1*26) + (w2+11)
         
         inp w      // x = 1, y = w2+11, z = E2, w = w3
         mul x 0    // x = 0, y = w2+11, z = E2, w = w3
         add x z    // x = E2, y = w2+11, z = E2, w = w3
         mod x 26   // x = mod(E2,26), y = w2+11, z = E2, w = w3
         div z 1    // x = mod(E2,26), y = w2+11, z = E2, w = w3
         add x 14   // x = mod(E2,26)+14, y = w2+11, z = E2, w = w3
         eql x w    // x = 0, y = w2+11, z = E2, w = w3
         eql x 0    // x = 1, y = w2+11, z = E2, w = w3
         mul y 0    // x = 0, y = 0, z = E2, w = w3
         add y 25   // x = 0, y = 25, z = E2, w = w3
         mul y x    // x = 0, y = 0, z = E2, w = w3
         add y 1    // x = 0, y = 1, z = E2, w = w3
         mul z y    // x = 0, y = 1, z = E2, w = w3
         mul y 0    // x = 0, y = 0, z = E2, w = w3
         add y w    // x = 0, y = w3, z = E2, w = w3
         add y 1    // x = 0, y = w3+1, z = E2, w = w3
         mul y x    // x = 0, y = 0, z = E2, w = w3
         add z y    // x = 0, y = 0, z = E2, w = w3
         
         // note: it appears w3 is *never* used
         // DEFINE E1 = (w1+1)
         // DEFINE E2 = (E1*26) + (w2+11)
         // DEFINE E3 = E2
         
         inp w      // x = 0, y = 0, z = E3, w = w4
         mul x 0    // x = 0, y = 0, z = E3, w = w4
         add x z    // x = E3, y = 0, z = E3, w = w4
         mod x 26   // x = mod(E3, 26), y = 0, z = E3, w = w4
         div z 1    // x = mod(E3, 26), y = 0, z = E3, w = w4
         add x 11   // x = mod(E3, 26)+11, y = 0, z = E3, w = w4
         eql x w    // x = 0, y = 0, z = E3, w = w4
         eql x 0    // x = 1, y = 0, z = E3, w = w4
         mul y 0    // x = 1, y = 0, z = E3, w = w4
         add y 25   // x = 1, y = 25, z = E3, w = w4
         mul y x    // x = 1, y = 25, z = E3, w = w4
         add y 1    // x = 1, y = 26, z = E3, w = w4
         mul z y    // x = 1, y = 26, z = E3*26, w = w4
         mul y 0    // x = 1, y = 0, z = E3*26, w = w4
         add y w    // x = 1, y = w4, z = E3*26, w = w4
         add y 11   // x = 1, y = w4+11, z = E3*26, w = w4
         mul y x    // x = 1, y = w4+11, z = E3*26, w = w4
         add z y    // x = 1, y = w4+11, z = (E3*26) + (w4+11), w = w4
         
         // DEFINE E1 = (w1+1)
         // DEFINE E2 = (((w1+1)*26) + (w2+11))
         // DEFINE E3 = E2
         // DEFINE E4 = ((((w1+1)*26) + (w2+11))*26) + (w4+11)
         
         inp w      // x = 1, y = w4+11, z = E4, w = w5
         mul x 0    // x = 0, y = w4+11, z = E4, w = w5
         add x z    // x = E4, y = w4+11, z = E4, w = w5
         mod x 26   // x = mod(E4,26), y = w4+11, z = E4, w = w5
         div z 26   // x = mod(E4,26), y = w4+11, z = div(E4,26), w = w5
         add x -8   // x = mod(E4,26)-8, y = w4+11, z = div(E4,26), w = w5
         
         // LET Q1 = mod(E4,26)-8 === w5
         eql x w    // x = Q1, y = w4+11, z = div(E4,26), w = w5
         
         // LET Q2 = Q1 === 0
         eql x 0    // x = Q2, y = w4+11, z = div(E4,26), w = w5
         mul y 0    // x = Q2, y = 0, z = div(E4,26), w = w5
         add y 25   // x = Q2, y = 25, z = div(E4,26), w = w5
         mul y x    // x = Q2, y = Q2 * 25, z = div(E4,26), w = w5
         add y 1    // x = Q2, y = (Q2 * 25) + 1, z = div(E4,26), w = w5
         mul z y    // x = Q2, y = (Q2 * 25) + 1, z = div(E4,26) * ((Q2 * 25) + 1), w = w5
         mul y 0    // x = Q2, y = 0, z = div(E4,26) * ((Q2 * 25) + 1), w = w5
         add y w    // x = Q2, y = w5, z = div(E4,26) * ((Q2 * 25) + 1), w = w5
         add y 2    // x = Q2, y = w5+2, z = div(E4,26) * ((Q2 * 25) + 1), w = w5
         mul y x    // x = Q2, y = Q2*(w5+2), z = div(E4,26) * ((Q2 * 25) + 1), w = w5
         add z y    // x = Q2, y = Q2*(w5+2), z = (div(E4,26) * ((Q2 * 25) + 1)) + (Q2*(w5+2)), w = w5
         
         // DEFINE E5 = (div(E4,26) * ((Q2 * 25) + 1)) + (Q2*(w5+2))
         
         inp w      // x = Q2, y = Q2*(w5+2), z = E5, w = w6
         mul x 0    // x = 0, y = Q2*(w5+2), z = E5, w = w6
         add x z    // x = E5, y = Q2*(w5+2), z = E5, w = w6
         mod x 26   // x = mod(E5,26), y = Q2*(w5+2), z = E5, w = w6
         div z 26   // x = mod(E5,26), y = Q2*(w5+2), z = div(E5,26), w = w6
         add x -5   // x = mod(E5,26)-5, y = Q2*(w5+2), z = div(E5,26), w = w6
         
         // LET Q3 = mod(E5,26)-5 === w6
         eql x w    // x = Q3, y = Q2*(w5+2), z = div(E5,26), w = w6
         
         // LET Q4 = Q3 === 0
         eql x 0    // x = Q4, y = Q2*(w5+2), z = div(E5,26), w = w6
         mul y 0    // x = Q4, y = 0, z = div(E5,26), w = w6
         add y 25   // x = Q4, y = 25, z = div(E5,26), w = w6
         mul y x    // x = Q4, y = Q4 * 25, z = div(E5,26), w = w6
         add y 1    // x = Q4, y = (Q4 * 25)+1, z = div(E5,26), w = w6
         mul z y    // x = Q4, y = (Q4 * 25)+1, z = div(E5,26) * ((Q4 * 25)+1), w = w6
         mul y 0    // x = Q4, y = 0, z = div(E5,26) * ((Q4 * 25)+1), w = w6
         add y w    // x = Q4, y = w6, z = div(E5,26) * ((Q4 * 25)+1), w = w6
         add y 9    // x = Q4, y = w6+9, z = div(E5,26) * ((Q4 * 25)+1), w = w6
         mul y x    // x = Q4, y = Q4 * (w6+9), z = div(E5,26) * ((Q4 * 25)+1), w = w6
         add z y    // x = Q4, y = Q4 * (w6+9), z = (div(E5,26) * ((Q4 * 25)+1)) + (Q4 * (w6+9)), w = w6
         
         // DEFINE E6 = (div(E5,26) * ((Q4 * 25)+1)) + (Q4 * (w6+9))
         
         inp w      // x = Q4, y = Q4 * (w6+9), z = E6, w = w7
         mul x 0    // x = 0, y = Q4 * (w6+9), z = E6, w = w7
         add x z    // x = E6, y = Q4 * (w6+9), z = E6, w = w7
         mod x 26   // x = mod(E6,26), y = Q4 * (w6+9), z = E6, w = w7
         div z 1    // x = mod(E6,26), y = Q4 * (w6+9), z = E6, w = w7
         add x 11   // x = mod(E6,26)+11, y = Q4 * (w6+9), z = E6, w = w7
         eql x w    // x = 0, y = Q4 * (w6+9), z = E6, w = w7
         eql x 0    // x = 1, y = Q4 * (w6+9), z = E6, w = w7
         mul y 0    // x = 1, y = 0, z = E6, w = w7
         add y 25   // x = 1, y = 25, z = E6, w = w7
         mul y x    // x = 1, y = 25, z = E6, w = w7
         add y 1    // x = 1, y = 26, z = E6, w = w7
         mul z y    // x = 1, y = 26, z = E6 * 26, w = w7
         mul y 0    // x = 1, y = 0, z = E6 * 26, w = w7
         add y w    // x = 1, y = w7, z = E6 * 26, w = w7
         add y 7    // x = 1, y = w7+7, z = E6 * 26, w = w7
         mul y x    // x = 1, y = w7+7, z = E6 * 26, w = w7
         add z y    // x = 1, y = w7+7, z = (E6 * 26) + (w7+7), w = w7
         
         // DEFINE E7 = (E6 * 26) + (w7+7)
         
         inp w      // x = 1, y = w7+7, z = E7, w = w8
         mul x 0    // x = 0, y = w7+7, z = E7, w = w8
         add x z    // x = E7, y = w7+7, z = E7, w = w8
         mod x 26   // x = mod(E7,26), y = w7+7, z = E7, w = w8
         div z 26   // x = mod(E7,26), y = w7+7, z = div(E7/26), w = w8
         add x -13  // x = mod(E7,26)-13, y = w7+7, z = div(E7/26), w = w8
         
         // LET Q5 = mod(E7,26)-13 === w8
         eql x w    // x = Q5, y = w7+7, z = div(E7/26), w = w8
         
         // LET Q6 = Q5 === 0
         eql x 0    // x = Q6, y = w7+7, z = div(E7/26), w = w8
         mul y 0    // x = Q6, y = 0, z = div(E7/26), w = w8
         add y 25   // x = Q6, y = 25, z = div(E7/26), w = w8
         mul y x    // x = Q6, y = Q6 * 25, z = div(E7/26), w = w8
         add y 1    // x = Q6, y = (Q6 * 25)+1, z = div(E7/26), w = w8
         mul z y    // x = Q6, y = (Q6 * 25)+1, z = div(E7/26) * ((Q6 * 25)+1), w = w8
         mul y 0    // x = Q6, y = 0, z = div(E7/26) * ((Q6 * 25)+1), w = w8
         add y w    // x = Q6, y = w8, z = div(E7/26) * ((Q6 * 25)+1), w = w8
         add y 11   // x = Q6, y = w8+11, z = div(E7/26) * ((Q6 * 25)+1), w = w8
         mul y x    // x = Q6, y = Q6*(w8+11), z = div(E7/26) * ((Q6 * 25)+1), w = w8
         add z y    // x = Q6, y = Q6*(w8+11), z = (div(E7/26) * ((Q6 * 25)+1)) + (Q6*(w8+11)), w = w8
         
         // DEFINE E8 = (div(E7/26) * ((Q6 * 25)+1)) + (Q6*(w8+11))
         
         inp w      // x = Q6, y = Q6*(w8+11), z = E8, w = w9
         mul x 0    // x = 0, y = Q6*(w8+11), z = E8, w = w9
         add x z    // x = E8, y = Q6*(w8+11), z = E8, w = w9
         mod x 26   // x = mod(E8,26), y = Q6*(w8+11), z = E8, w = w9
         div z 1    // x = mod(E8,26), y = Q6*(w8+11), z = E8, w = w9
         add x 12   // x = mod(E8,26)+12, y = Q6*(w8+11), z = E8, w = w9
         eql x w    // x = 0, y = Q6*(w8+11), z = E8, w = w9
         eql x 0    // x = 1, y = Q6*(w8+11), z = E8, w = w9
         mul y 0    // x = 1, y = 0, z = E8, w = w9
         add y 25   // x = 1, y = 25, z = E8, w = w9
         mul y x    // x = 1, y = 25, z = E8, w = w9
         add y 1    // x = 1, y = 26, z = E8, w = w9
         mul z y    // x = 1, y = 26, z = 26 * E8, w = w9
         mul y 0    // x = 1, y = 0, z = 26 * E8, w = w9
         add y w    // x = 1, y = w9, z = 26 * E8, w = w9
         add y 6    // x = 1, y = w9+6, z = 26 * E8, w = w9
         mul y x    // x = 1, y = w9+6, z = 26 * E8, w = w9
         add z y    // x = 1, y = w9+6, z = (26 * E8) + (w9+6), w = w9
         
         // DEFINE E9 = (26 * E8) + (w9+6)
         
         inp w      // x = 1, y = w9+6, z = E9, w = w10
         mul x 0    // x = 0, y = w9+6, z = E9, w = w10
         add x z
         mod x 26
         div z 26
         add x -1
         eql x w
         eql x 0
         mul y 0
         add y 25
         mul y x
         add y 1
         mul z y
         mul y 0
         add y w
         add y 15
         mul y x
         add z y
         
         inp w
         mul x 0
         add x z
         mod x 26
         div z 1
         add x 14
         eql x w
         eql x 0
         mul y 0
         add y 25
         mul y x
         add y 1
         mul z y
         mul y 0
         add y w
         add y 7
         mul y x
         add z y
         
         inp w
         mul x 0
         add x z
         mod x 26
         div z 26
         add x -5
         eql x w
         eql x 0
         mul y 0
         add y 25
         mul y x
         add y 1
         mul z y
         mul y 0
         add y w
         add y 1
         mul y x
         add z y
         
         inp w
         mul x 0
         add x z
         mod x 26
         div z 26
         add x -4
         eql x w
         eql x 0
         mul y 0
         add y 25
         mul y x
         add y 1
         mul z y
         mul y 0
         add y w
         add y 8
         mul y x
         add z y
         
         inp w
         mul x 0
         add x z
         mod x 26
         div z 26
         add x -8
         eql x w
         eql x 0
         mul y 0
         add y 25
         mul y x
         add y 1
         mul z y
         mul y 0
         add y w
         add y 6
         mul y x
         add z y

         */
        
        return variables["z"] == 0
    }

    func part2() async throws -> Int {
        return 0
    }

}

extension Int {
    fileprivate static func ===(lhs: Self, rhs: Self) -> Int {
        return lhs == rhs ? 1 : 0
    }
}
