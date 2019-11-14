//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/7/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

class Day8: Day {
    
    struct Node {
        let children: Array<Node>
        let metadata: Array<Int>
        
        var metadataSum: Int {
            return metadata.sum() + children.map { $0.metadataSum }.sum()
        }
        
        var value: Int {
            if children.isEmpty { return metadata.sum() }
            return metadata.map { children.at($0 - 1)?.value ?? 0 }.sum()
        }
    }
    
    @objc init() { super.init(inputFile: #file) }
    
    private func parse<I: IteratorProtocol>(_ integers: inout I) -> Node where I.Element == Int {
        let childCount = integers.next()!
        let metadataCount = integers.next()!
        
        let children = (0..<childCount).map { _ in parse(&integers) }
        let metadata = (0..<metadataCount).map { _ in integers.next()! }
        return Node(children: children, metadata: metadata)
    }
    
    override func run() -> (String, String) {
        var integers = input.words.integers.makeIterator()
        let tree = parse(&integers)
        return ("\(tree.metadataSum)", "\(tree.value)")
    }

}
