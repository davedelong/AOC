//
//  LinkedList.swift
//  AOC
//
//  Created by Dave DeLong on 12/8/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import Foundation

public enum CircularList_Old {
    
    public class Node<T> {
        
        public let value: T
        private var ccw: Node<T>!
        private var cw: Node<T>!
        
        public init(_ value: T) {
            self.value = value
            ccw = self
            cw = self
        }
        
        public convenience init<C: Collection>(values: C) where C.Element == T {
            self.init(values.first!)
            
            var current: Node<T> = self
            for value in values.dropFirst() {
                current = current.insert(after: value)
            }
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
        
        public func removeAfter() -> T {
            let value = cw!.value
            let cw2 = cw!.cw!
            
            cw = cw2
            cw2.ccw = self
            return value
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

extension CircularList_Old.Node where T: Equatable {
    
    public func find(value: T) -> CircularList_Old.Node<T>? {
        var current = self
        repeat {
            if current.value == value { return current }
            current = current.cw
        } while current !== self
        return nil
    }
    
}
