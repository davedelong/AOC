//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/14/21.
//

import XCTest
@testable import AOCCore

class TestGraph: XCTestCase {
    
    func testBasicEquality() {
        let g1 = Graph<String, String>()
        let g2 = Graph<String, String>()
        XCTAssertEqual(g1, g2)
        
        let g3 = g1
        XCTAssertEqual(g1, g3)
        
        let gg1 = GridGraph<String>(width: 10, height: 10)
        let gg2 = GridGraph<String>(width: 10, height: 10)
        XCTAssertEqual(gg1, gg2)
        
        let gg3 = gg1
        XCTAssertEqual(gg1, gg3)
    }
    
    func testStructuralEquality() {
        var g1 = Graph<String, Int>()
        g1["a"] = 1
        g1["b"] = 2
        
        let g2 = g1
        XCTAssertEqual(g1, g2)
        
        g1.connect("a", to: "b")
        XCTAssertNotEqual(g1, g2)
        
        g1.disconnect("a", from: "b")
        XCTAssertEqual(g1, g2)
        
        g1["c"] = 3
        XCTAssertNotEqual(g1, g2)
        
        g1["c"] = nil
        XCTAssertEqual(g1, g2)
        
        g1["a"] = 4
        XCTAssertNotEqual(g1, g2)
        
        g1["a"] = 1
        XCTAssertEqual(g1, g2)
    }
    
    func testGridStructuralEquality() {
        var g1 = GridGraph<Int>(width: 2, height: 2)
        g1[.zero] = 1
        g1[0, 1] = 2
        
        XCTAssertEqual(g1.rect, PointRect(origin: .zero, width: 2, height: 2))
        
        let g2 = g1
        XCTAssertEqual(g1, g2)
        
        g1[.zero] = nil
        XCTAssertNotEqual(g1, g2)
        
        g1[.zero] = 1
        XCTAssertEqual(g1, g2)
        
        let connections = g1.connections(from: .zero)
        XCTAssertEqual(connections, [
            Position(x: 1, y: 0),
            Position(x: 0, y: 1)
        ])
    }
    
    func testGraphCosts() {
        var g = Graph<String, Int>()
        g["a"] = 1
        g["b"] = 2
        g["c"] = 3
        
        g.connect("a", to: "b")
        g.connect("b", to: "c")
        
        XCTAssertEqual(g.cost(from: "a", to: "a"), 0)
        XCTAssertEqual(g.cost(from: "a", to: "b"), 1)
        XCTAssertEqual(g.cost(from: "a", to: "c"), 2)
        
        g[exitCost: "a"] = 1
        XCTAssertEqual(g[exitCost: "a"], 1)
        XCTAssertEqual(g.cost(from: "a", to: "b"), 2)
        XCTAssertEqual(g.cost(from: "a", to: "c"), 3)
        
        g.setTravelCost(2, from: "a", to: "b")
        XCTAssertEqual(g.travelCost(from: "a", to: "b"), 2)
        XCTAssertEqual(g.cost(from: "a", to: "b"), 3)
        XCTAssertEqual(g.cost(from: "a", to: "c"), 4)
        
        g[entranceCost: "b"] = 1
        XCTAssertEqual(g[entranceCost: "b"], 1)
        XCTAssertEqual(g.cost(from: "a", to: "b"), 4)
        XCTAssertEqual(g.cost(from: "a", to: "c"), 5)
        
        g[exitCost: "b"] = 1
        XCTAssertEqual(g[exitCost: "b"], 1)
        XCTAssertEqual(g.cost(from: "b", to: "c"), 2)
        XCTAssertEqual(g.cost(from: "a", to: "c"), 6)
        
        g.setTravelCost(2, from: "b", to: "c")
        XCTAssertEqual(g.travelCost(from: "b", to: "c"), 2)
        XCTAssertEqual(g.cost(from: "a", to: "c"), 7)
        
        var g2 = Graph<String, Int>()
        g2.defaultTravelCost = 2
        g2["a"] = 1
        g2["b"] = 2
        g2.connect("a", to: "b")
        XCTAssertEqual(g2.travelCost(from: "a", to: "b"), 2)
        XCTAssertEqual(g2.cost(from: "a", to: "b"), 2)
    }
    
    func testGridGraphCosts() {
        let a = Position(x: 0, y: 0)
        let b = Position(x: 1, y: 0)
        let c = Position(x: 2, y: 0)
        var g = GridGraph<Int>(width: 3, height: 1)
        
        g[a] = 1
        g[b] = 2
        g[c] = 3
        
        XCTAssertEqual(g.cost(from: a, to: a), 0)
        XCTAssertEqual(g.cost(from: a, to: b), 1)
        XCTAssertEqual(g.cost(from: a, to: c), 2)
        
        g[exitCost: a] = 1
        XCTAssertEqual(g[exitCost: a], 1)
        XCTAssertEqual(g.cost(from: a, to: b), 2)
        XCTAssertEqual(g.cost(from: a, to: c), 3)
        
        g.setTravelCost(2, from: a, to: b)
        XCTAssertEqual(g.travelCost(from: a, to: b), 2)
        XCTAssertEqual(g.cost(from: a, to: b), 3)
        XCTAssertEqual(g.cost(from: a, to: c), 4)
        
        g[entranceCost: b] = 1
        XCTAssertEqual(g[entranceCost: b], 1)
        XCTAssertEqual(g.cost(from: a, to: b), 4)
        XCTAssertEqual(g.cost(from: a, to: c), 5)
        
        g[exitCost: b] = 1
        XCTAssertEqual(g[exitCost: b], 1)
        XCTAssertEqual(g.cost(from: b, to: c), 2)
        XCTAssertEqual(g.cost(from: a, to: c), 6)
        
        g.setTravelCost(2, from: b, to: c)
        XCTAssertEqual(g.travelCost(from: b, to: c), 2)
        XCTAssertEqual(g.cost(from: a, to: c), 7)
        
        var g2 = GridGraph<Int>(width: 3, height: 1)
        g2.defaultTravelCost = 2
        g2[a] = 1
        g2[b] = 2
        XCTAssertEqual(g2.travelCost(from: a, to: b), 2)
        XCTAssertEqual(g2.cost(from: a, to: b), 2)
    }
    
    func testNestedArrayInitializer() {
        let g = GridGraph([
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ])
        
        XCTAssertEqual(g.rect.count, 9)
        XCTAssertEqual(g[0, 0], 1)
        XCTAssertEqual(g[1, 0], 2)
        XCTAssertEqual(g[2, 0], 3)
        XCTAssertEqual(g[0, 1], 4)
        XCTAssertEqual(g[1, 1], 5)
        XCTAssertEqual(g[2, 1], 6)
        XCTAssertEqual(g[0, 2], 7)
        XCTAssertEqual(g[1, 2], 8)
        XCTAssertEqual(g[2, 2], 9)
    }
    
}
