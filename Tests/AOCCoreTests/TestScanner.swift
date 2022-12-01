//
//  File.swift
//  
//
//  Created by Dave DeLong on 11/30/22.
//

import XCTest
@testable import AOCCore

class TestScanner: XCTestCase {
    
    func testScanner() {
        var s = Scanner(data: "abcd")
        XCTAssertEqual(s.scanElement(), "a")
        XCTAssertEqual(s.scanElement(), "b")
        XCTAssertEqual(s.scanElement(), "c")
        XCTAssertEqual(s.scanElement(), "d")
        
        XCTAssertTrue(s.isAtEnd)
        XCTAssertNil(s.scanElement())
    }
    
    func testTryScan() {
        var s1 = Scanner(data: "abcd")
        XCTAssertTrue(s1.tryScan("a"))
        
        XCTAssertFalse(s1.tryScan("a"))
        XCTAssertTrue(s1.tryScan("b"))
        
        XCTAssertFalse(s1.tryScan("b"))
        XCTAssertTrue(s1.tryScan("c"))
        
        XCTAssertFalse(s1.tryScan("c"))
        XCTAssertTrue(s1.tryScan("d"))
        
        XCTAssertFalse(s1.tryScan("d"))
        
        var s2 = Scanner(data: "abcdefgh")
        XCTAssertTrue(s2.tryScan("abcd"))
        XCTAssertTrue(s2.tryScan("efgh"))
    }
    
    func testUpToScan() {
        var s1 = Scanner(data: "abcdefgh")
        XCTAssertNotNil(s1.scanUpTo("c"))
        XCTAssertTrue(s1.tryScan("c"))
        
        XCTAssertNotNil(s1.scanUpTo("gh"))
        XCTAssertTrue(s1.tryScan("gh"))
    }
}
