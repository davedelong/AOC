//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/15/21.
//

import XCTest
@testable import AOCCore

class TestPoint: XCTestCase {
    
    func testPointRect() {
        let p = PointRect(origin: .zero, width: 2, height: 2)
        XCTAssertEqual(p.count, 4)
        
        let points = Array(p)
        XCTAssertEqual(points, [
            Position(x: 0, y: 0),
            Position(x: 1, y: 0),
            Position(x: 0, y: 1),
            Position(x: 1, y: 1),
        ])
    }
    
    func testNormalizedSizeRect() {
        let p1 = PointRect(origin: Position(x: 1, y: 1), width: -1, height: -1)
        let p2 = PointRect(origin: .zero, width: 1, height: 1)
        XCTAssertEqual(p1, p2)
    }
    
    func testHalfOpenRangeRect() {
        let p = PointRect(xRange: 0 ..< 2, yRange: 0 ..< 2)
        XCTAssertEqual(p.count, 4)
        XCTAssertEqual(p.width, 2)
        XCTAssertEqual(p.height, 2)
        
        let points = Array(p)
        XCTAssertEqual(points, [
            Position(x: 0, y: 0),
            Position(x: 1, y: 0),
            Position(x: 0, y: 1),
            Position(x: 1, y: 1),
        ])
    }
    
    func testClosedRangeRect() {
        let p = PointRect(xRange: 0 ... 2, yRange: 0 ... 2)
        XCTAssertEqual(p.count, 9)
        XCTAssertEqual(p.width, 3)
        XCTAssertEqual(p.height, 3)
        
        let points = Array(p)
        XCTAssertEqual(points, [
            Position(x: 0, y: 0),
            Position(x: 1, y: 0),
            Position(x: 2, y: 0),
            Position(x: 0, y: 1),
            Position(x: 1, y: 1),
            Position(x: 2, y: 1),
            Position(x: 0, y: 2),
            Position(x: 1, y: 2),
            Position(x: 2, y: 2),
        ])
    }
    
}
