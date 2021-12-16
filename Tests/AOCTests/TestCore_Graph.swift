//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/14/21.
//

import XCTest
@testable import AOCCore

class TestCore_Graph: XCTestCase {
    
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
        XCTAssertEqual(Set(connections), [
            Position(x: 1, y: 0),
            Position(x: 0, y: 1)
        ])
    }
    
}
