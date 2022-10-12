//
//  Day18.swift
//  test
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

import MathParser

class Day18: Day {
    
    enum Operator {
        case multiply
        case add
    }
    
    indirect enum Expression {
        case value(Int)
        case operation(Expression, Operator, Expression)
        
        var evaluated: Int {
            switch self {
                case .value(let i): return i
                case .operation(let lhs, let op, let rhs):
                    let lValue = lhs.evaluated
                    let rValue = rhs.evaluated
                    switch op {
                        case .multiply: return lValue * rValue
                        case .add: return lValue + rValue
                    }
            }
        }
    }
    
    enum Either<A, B> {
        case left(A)
        case right(B)
        
        var left: A? {
            guard case .left(let l) = self else { return nil }
            return l
        }
        
        var right: B? {
            guard case .right(let r) = self else { return nil }
            return r
        }
    }
    
    private func parse(_ input: String) -> Expression {
        let compact = "(" + input.replacingOccurrences(of: " ", with: "") + ")"
        var slice = compact[...]
        return parseGroup(&slice)
    }
    
    private func parseGroup(_ characters: inout Substring) -> Expression {
        guard characters.removeFirst() == "(" else { fatalError() }
        
        var pieces = Array<Either<Expression, Operator>>()
        while let n = characters.first, n != ")" {
            if n.isNumber {
                pieces.append(.left(.value(Int("\(n)")!)))
                characters.removeFirst()
            } else if n == "+" {
                pieces.append(.right(.add))
                characters.removeFirst()
            } else if n == "*" {
                pieces.append(.right(.multiply))
                characters.removeFirst()
            } else if n == "(" {
                let sub = parseGroup(&characters)
                pieces.append(.left(sub))
            } else {
                print("UNKNOWN: \(n)")
            }
        }
        characters.removeFirst() // pop the ")"
        
        guard pieces.count.isMultiple(of: 2) == false else { fatalError() }
        while pieces.count > 1 {
            let slice = pieces[0..<3]
            let l = slice[0].left!
            let op = slice[1].right!
            let r = slice[2].left!
            pieces.replaceSubrange(0..<3, with: [.left(.operation(l, op, r))])
        }
        return pieces[0].left!
    }

    func part1() async throws -> Int {
        let expressions = input().lines.raw.map(parse(_:)).map(\.evaluated)
        return expressions.sum
    }

    func part2() async throws -> Int {
        
        let operators = OperatorSet()
        let cMul = MathParser.Operator(function: "•", arity: .binary, associativity: .left, tokens: ["•"])
        operators.addOperator(cMul, relatedBy: .equalTo, toOperator: .init(builtInOperator: .add))
        
        let cAdd = MathParser.Operator(function: "#", arity: .binary, associativity: .left, tokens: ["#"])
        operators.addOperator(cAdd, relatedBy: .equalTo, toOperator: .init(builtInOperator: .multiply))
        
        let e = Evaluator()
        var config = Configuration()
        config.operatorSet = operators
        
        let expressions = input().lines.raw.map { line -> MathParser.Expression in
            let final = line
                .replacingOccurrences(of: "+", with: "#")
                .replacingOccurrences(of: "*", with: "•")
            do {
                let parsed = try MathParser.Expression(string: final, configuration: config)
                return parsed
            } catch {
                print(error)
                fatalError()
            }
        }
        
        try! e.registerFunction(Function(name: "#", evaluator: { (state) -> Double in
            let lhs = try state.evaluator.evaluate(state.arguments[0])
            let rhs = try state.evaluator.evaluate(state.arguments[1])
            return lhs + rhs
        }))
        
        try! e.registerFunction(Function(name: "•", evaluator: { (state) -> Double in
            let lhs = try state.evaluator.evaluate(state.arguments[0])
            let rhs = try state.evaluator.evaluate(state.arguments[1])
            return lhs * rhs
        }))
        
        let evald = expressions.map { exp -> Int in
            let value = try! e.evaluate(exp)
            return Int(value)
        }
        
        return evald.sum
    }

}
