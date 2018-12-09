//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/8/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

extension Year2018 {

    public class Day9: Day {
        
        class Node<T> {
            let value: T
            var ccw: Node<T>!
            var cw: Node<T>!
            init(_ value: T) {
                self.value = value
                ccw = self
                cw = self
            }
            
            func insert(after value: T) -> Node<T> {
                let after = cw!
                
                let n = Node(value)
                cw = n
                n.ccw = self
                
                after.ccw = n
                n.cw = after
                return n
            }
            
            func insert(before value: T) -> Node<T> {
                let before = ccw!
                return before.insert(after: value)
            }
            
            func remove() -> (Node<T>, Node<T>) {
                let before = ccw!
                let after = cw!
                
                before.cw = after
                after.ccw = before
                
                cw = nil
                ccw = nil
                
                return (before, after)
            }
            
            func cw(_ amount: Int = 1) -> Node<T> {
                var c = self
                for _ in 0 ..< amount { c = c.cw }
                return c
            }
            
            func ccw(_ amount: Int = 1) -> Node<T> {
                var c = self
                for _ in 0 ..< amount { c = c.ccw }
                return c
            }
        }
        
        public init() { super.init(inputSource: .none) }
        
        private func computeHighestScore(players: Int, lastMarbleScore: Int) -> Int {
            var scores = Array(repeating: 0, count: players)
            var currentPlayer = 0
            
            var currentMarble = Node(0)
            
            for marbleScore in 1...lastMarbleScore {
                if marbleScore % 23 == 0 {
                    scores[currentPlayer] += marbleScore
                    currentMarble = currentMarble.ccw(7)
                    scores[currentPlayer] += currentMarble.value
                    (_, currentMarble) = currentMarble.remove()
                } else {
                    currentMarble = currentMarble.cw!.insert(after: marbleScore)
                }
                currentPlayer = (currentPlayer + 1) % players
            }
            
            return scores.max()!
        }
        
        override public func part1() -> String {
            let s = computeHighestScore(players: 471, lastMarbleScore: 72026)
            return "\(s)"
        }
        
        override public func part2() -> String {
            let s = computeHighestScore(players: 471, lastMarbleScore: 7202600)
            return "\(s)"
        }
        
    }

}
