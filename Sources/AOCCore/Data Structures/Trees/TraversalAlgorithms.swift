//
//  TraversalAlgorithms.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 7/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct PreOrderTraversal<N: TreeNode>: TreeTraversing {
    public typealias Node = N
    
    public enum Disposition: TreeTraversingDisposition {
        public static var keepGoing: Disposition { return .continue }
        
        case abort
        case `continue`
        case skipChildren
        
        public var aborts: Bool { return self == .abort }
    }
    
    public init() { }
    
    public func traverse(node: Node, level: Int, visitor: (Node, Int) throws -> Disposition) rethrows -> Disposition {
        let d = try visitor(node, level)
        if d.aborts { return d }
        
        if d != .skipChildren {
            for child in node.children {
                let nodeD = try traverse(node: child, level: level+1, visitor: visitor)
                if nodeD.aborts { return nodeD }
            }
        }
        return .continue
    }
    
}

public struct PostOrderTraversal<N: TreeNode>: TreeTraversing {
    public typealias Node = N
    public enum Disposition: TreeTraversingDisposition {
        public static var keepGoing: Disposition { return .continue }
        
        case abort
        case `continue`
        
        public var aborts: Bool { return self == .abort }
    }
    
    public init() { }
    
    public func traverse(node: N, level: Int, visitor: (N, Int) throws -> Disposition) rethrows -> Disposition {
        for child in node.children {
            let nodeD = try traverse(node: child, level: level+1, visitor: visitor)
            if nodeD.aborts { return nodeD }
        }
        
        return try visitor(node, level)
    }
}

public struct BreadthFirstTreeTraversal<N: TreeNode>: TreeTraversing {
    public typealias Node = N
    public enum Disposition: TreeTraversingDisposition {
        public static var keepGoing: Disposition { return .continue }
        
        case abort
        case `continue`
        case skipChildren
        
        public var aborts: Bool { return self == .abort }
    }
    
    public func traverse(node: N, level: Int, visitor: (N, Int) throws -> Disposition) rethrows -> Disposition {
        var nodesToVisit = ArraySlice([(node, level)])
        
        while let (nextNode, nodeLevel) = nodesToVisit.popFirst() {
            let nodeDisposition = try visitor(nextNode, nodeLevel)
            switch nodeDisposition {
                case .abort: return .abort
                case .continue: nodesToVisit.append(contentsOf: nextNode.children.map { ($0, nodeLevel + 1) })
                case .skipChildren: continue
            }
        }
        
        return .continue
        
    }
    
}

// In-order traversal only works on binary tree nodes, because general tree nodes don't have a notion of "left" or "right" children
public struct InOrderTraversal<N: BinaryTreeNode>: TreeTraversing {
    public typealias Node = N
    
    public enum Disposition: TreeTraversingDisposition {
        public static var keepGoing: Disposition { return .continue }
        
        case abort
        case `continue`
        case skipChildren
        
        public var aborts: Bool { return self == .abort }
    }
    
    public func traverse(node: N, level: Int, visitor: (N, Int) throws -> Disposition) rethrows -> Disposition {
        if let l = node.left {
            let d = try traverse(node: l, level: level+1, visitor: visitor)
            if d.aborts { return d }
        }
        
        let d = try visitor(node, level)
        if d.aborts { return d }
        
        if let r = node.right, d != .skipChildren {
            let d = try traverse(node: r, level: level+1, visitor: visitor)
            if d.aborts { return d }
        }
        
        return .continue
    }
}
