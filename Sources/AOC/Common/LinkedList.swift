//
//  LinkedList.swift
//  AOC
//
//  Created by Dave DeLong on 12/8/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public enum CircularList {
    
    public class Node<T> {
        
        public let value: T
        private var ccw: Node<T>!
        private var cw: Node<T>!
        
        public init(_ value: T) {
            self.value = value
            ccw = self
            cw = self
        }
        
        public func insert(after value: T) -> Node<T> {
            let after = cw!
            
            let n = Node(value)
            cw = n
            n.ccw = self
            
            after.ccw = n
            n.cw = after
            return n
        }
        
        public func insert(before value: T) -> Node<T> {
            let before = ccw!
            return before.insert(after: value)
        }
        
        public func remove() -> (Node<T>, Node<T>) {
            let before = ccw!
            let after = cw!
            
            before.cw = after
            after.ccw = before
            
            cw = nil
            ccw = nil
            
            return (before, after)
        }
        
        public func cw(_ amount: Int = 1) -> Node<T> {
            var c = self
            for _ in 0 ..< amount { c = c.cw }
            return c
        }
        
        public func ccw(_ amount: Int = 1) -> Node<T> {
            var c = self
            for _ in 0 ..< amount { c = c.ccw }
            return c
        }
        
    }
    
}
