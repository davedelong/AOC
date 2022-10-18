//
//  File.swift
//  
//
//  Created by Dave DeLong on 10/16/22.
//

import XCTest
import AOCCore

class TestCircularList: XCTestCase {
    
    func testSequence() {
        let c1 = CircularList(1)
        XCTAssertFalse(c1.isEmpty)
        
        var i1 = c1.makeIterator()
        XCTAssertEqual(i1.next(), 1)
        XCTAssertNil(i1.next())
        
        let c2 = CircularList(1...3)
        var i2 = c2.makeIterator()
        XCTAssertEqual(i2.next(), 1)
        XCTAssertEqual(i2.next(), 2)
        XCTAssertEqual(i2.next(), 3)
        XCTAssertNil(i2.next())
    }
    
    func testCircular() {
        do {
            let c1 = CircularList(1)
            let i1 = c1.startIndex
            XCTAssertEqual(i1, c1.index(after: i1))
            XCTAssertEqual(i1, c1.index(before: i1))
        }
        
        do {
            let c2 = CircularList([1, 2, 3])
            let i1 = c2.startIndex
            let i2 = c2.index(after: i1)
            let i3 = c2.index(after: i2)
            XCTAssertEqual(i3, c2.index(before: i1))
            XCTAssertEqual(i1, c2.index(after: i3))
        }
        
        do {
            let c3 = CircularList(1, 2, 3)
            var i = c3.startIndex
            XCTAssertEqual(c3[i], 1)
            c3.formIndex(after: &i)
            XCTAssertEqual(c3[i], 2)
            c3.formIndex(after: &i)
            XCTAssertEqual(c3[i], 3)
            c3.formIndex(after: &i)
            XCTAssertEqual(c3[i], 1)
            c3.formIndex(before: &i)
            XCTAssertEqual(c3[i], 3)
        }
    }
    
    func testIndices() {
        XCTAssertEqual(CircularList<Int>().indices, [])
        
        let c1 = CircularList(1, 2, 3)
        let idx = c1.indices
        XCTAssertEqual(c1[idx[0]], 1)
        XCTAssertEqual(c1[idx[1]], 2)
        XCTAssertEqual(c1[idx[2]], 3)
    }
    
    func testInsertion() {
        var c1 = CircularList(1)
        let i1 = c1.startIndex
        
        let i2 = c1.insert(2, after: i1)
        let i3 = c1.insert(3, after: i2)
        
        XCTAssertEqual(i2, c1.index(after: i1))
        XCTAssertEqual(i3, c1.index(after: i2))
        XCTAssertEqual(i1, c1.index(after: i3))
        
        XCTAssertEqual(i3, c1.index(before: i1))
        XCTAssertEqual(i2, c1.index(before: i3))
        XCTAssertEqual(i1, c1.index(before: i2))
        
        let i4 = c1.insert(42, after: i2)
        // 1, 2, 42, 3
        XCTAssertEqual(c1.elements(), [1, 2, 42, 3])
        XCTAssertEqual(c1.count, 4)
        
        let i5 = c1.insert(13, before: i2)
        // 1, 13, 2, 42, 3
        XCTAssertEqual(c1.elements(), [1, 13, 2, 42, 3])
        XCTAssertEqual(c1.count, 5)
        
    }
    
    func testRemoval() {
        var c1 = CircularList(1)
        let i1 = c1.startIndex
        
        let i2 = c1.insert(2, after: i1)
        let i3 = c1.insert(3, after: i2)
        
        let _ = c1.removeValue(at: i2)
        XCTAssertEqual(i3, c1.index(after: i1))
        XCTAssertEqual(i1, c1.index(after: i3))
    }
    
    func testCOWReplacing() {
        var c1 = CircularList(2)
        let c2 = c1
        c1[c1.startIndex] = 1
        
        XCTAssertNotEqual(c1, c2)
        XCTAssertEqual(c1[c1.startIndex], 1)
        XCTAssertEqual(c2[c2.startIndex], 2)
    }
    
    func testEmptying() {
        var c1 = CircularList([1, 2, 3])
        c1.removeAllValues()
        XCTAssertEqual(c1.count, 0)
        XCTAssertTrue(c1.isEmpty)
    }
    
    func testEmpty() {
        let c1 = CircularList<Int>()
        XCTAssertTrue(c1.isEmpty)
        XCTAssertEqual(c1.count, 0)
        XCTAssertEqual(c1.elements(), [])
        
        var c2 = CircularList<Int>()
        let i1 = c2.startIndex
        c2[i1] = 1
        XCTAssertEqual(c2.count, 1)
    }
    
    func testCOW() {
        let c1 = CircularList([1, 2, 3])
        var c2 = c1
        
        let i1 = c2.startIndex
        XCTAssertEqual(c2[i1], 1)
        let i2 = c2.index(after: i1)
        XCTAssertEqual(2, c2.removeValue(at: i2))
        XCTAssertEqual(c2.count, 2)
        XCTAssertEqual(c1.count, 3)
        
        do {
            var c3 = c1
            let i1 = c3.startIndex
            c3.insert(4, after: i1)
            XCTAssertEqual(c3.elements(), [1, 4, 2, 3])
            XCTAssertEqual(c1.elements(), [1, 2, 3])
        }
    }
    
    func testEquality() {
        XCTAssertEqual(CircularList<Int>(), CircularList<Int>())
        
        let c1 = CircularList(1, 2, 3)
        let c2 = CircularList(2, 3, 1)
        XCTAssertEqual(c1, c2)
        XCTAssertEqual(c2, c2)
        
        let c3 = CircularList(1, 2)
        XCTAssertNotEqual(c1, c3)
        
        let c4 = CircularList(2, 3, 4)
        XCTAssertNotEqual(c1, c4)
        
        let c5 = CircularList(1, 2, 4)
        XCTAssertNotEqual(c1, c5)
        
        let c6 = CircularList(1, 2, 3, 1, 2, 3)
        let c7 = CircularList(1, 2, 1, 2, 1, 2)
        XCTAssertNotEqual(c6, c7)
    }
    
    func testLookup() {
        let c1 = CircularList(1, 2, 3)
        let a1 = c1.indices(of: 1)
        XCTAssertEqual(a1, [c1.startIndex])
    }
    
    func testOffsetting() {
        let c1 = CircularList(1, 2, 3, 4)
        let i1 = c1.startIndex
        XCTAssertEqual(i1, c1.index(i1, offsetBy: 0))
        
        let i2 = c1.index(i1, offsetBy: 1)
        XCTAssertEqual(i2, c1.index(after: i1))
        
        let i3 = c1.index(i1, offsetBy: 2)
        XCTAssertEqual(i3, c1.index(after: i2))
        
        let i4 = c1.index(i1, offsetBy: 3)
        XCTAssertEqual(i4, c1.index(after: i3))
        
        let wrap = c1.index(i1, offsetBy: 4)
        XCTAssertEqual(i1, wrap)
        
        var i = c1.startIndex
        c1.formIndex(&i, offsetBy: 2)
        XCTAssertEqual(c1[i], 3)
        c1.formIndex(&i, offsetBy: 4)
        XCTAssertEqual(c1[i], 3)
        
        XCTAssertEqual(i2, c1.index(relativeTo: i1, direction: .forward))
        XCTAssertEqual(i4, c1.index(relativeTo: i1, direction: .backward))
    }
    
    func testLimitedOffsetting() {
        let c1 = CircularList(1, 2, 3, 4)
        let i1 = c1.startIndex
        let i2 = c1.index(after: i1)
        let i3 = c1.index(after: i2)
        let i4 = c1.index(after: i3)
        
        let l2 = c1.index(i1, offsetBy: 1, limitedBy: i2)
        XCTAssertEqual(i2, l2)
        
        let l3 = c1.index(i1, offsetBy: 2, limitedBy: i2)
        XCTAssertNil(l3)
        
        let l4 = c1.index(i1, offsetBy: -2, limitedBy: i2)
        XCTAssertEqual(i3, l4)
        
        let l5 = c1.index(i1, offsetBy: -2, limitedBy: i4)
        XCTAssertNil(l5)
        
        var l6 = i1
        XCTAssertFalse(c1.formIndex(&l6, offsetBy: 2, limitedBy: i2))
        XCTAssertEqual(l6, i2)
        
        var l7 = i1
        XCTAssertFalse(c1.formIndex(&l7, offsetBy: -2, limitedBy: i4))
        XCTAssertEqual(l7, i4)
    }
    
    func testFinding() {
        let c1 = CircularList(1, 2, 1, 2)
        let i1 = c1.startIndex
        let i2 = c1.index(after: i1)
        let i3 = c1.index(after: i2)
        let i4 = c1.index(after: i3)
        
        XCTAssertNil(c1.nextIndex(of: 3))
        XCTAssertEqual(i1, c1.nextIndex(of: 1))
        
        XCTAssertEqual(i2, c1.nextIndex(of: 2, searchDirection: .forward))
        XCTAssertEqual(i4, c1.nextIndex(of: 2, searchDirection: .backward))
        
        XCTAssertEqual(i1, c1.nextIndex(of: 1, startingAt: i2, searchDirection: .backward))
        XCTAssertEqual(i3, c1.nextIndex(of: 1, startingAt: i2, searchDirection: .forward))
    }
    
}
