//
//  File.swift
//  
//
//  Created by Dave DeLong on 12/22/21.
//

import XCTest
@testable import AOCCore

class TestVector: XCTestCase {
    
    func testOrthogonalAdajecents() {
        let a = Vector2.adjacents(orthogonalOnly: true, includingSelf: false)
        XCTAssertEqual(a, [
            Vector2([-1, 0]),
            Vector2([0, -1]),
            Vector2([0, 1]),
            Vector2([1, 0]),
        ])
        
        let b = Vector3.adjacents(orthogonalOnly: true, includingSelf: false)
        XCTAssertEqual(b, [
            Vector3([-1, 0, 0]),
            Vector3([0, -1, 0]),
            Vector3([0, 0, -1]),
            Vector3([0, 0, 1]),
            Vector3([0, 1, 0]),
            Vector3([1, 0, 0])
        ])
        
    }
    
    func testAllAdajacents() {
        let a = Vector2.adjacents(orthogonalOnly: false, includingSelf: false)
        XCTAssertEqual(a, [
            Vector2([-1, -1]),
            Vector2([-1, 0]),
            Vector2([-1, 1]),
            Vector2([0, -1]),
            Vector2([0, 1]),
            Vector2([1, -1]),
            Vector2([1, 0]),
            Vector2([1, 1]),
        ])
        
        let b = Vector3.adjacents(orthogonalOnly: false, includingSelf: false)
        XCTAssertEqual(b, [
            Vector3([-1, -1, -1]),
            Vector3([-1, -1, 0]),
            Vector3([-1, -1, 1]),
            Vector3([-1, 0, -1]),
            Vector3([-1, 0, 0]),
            Vector3([-1, 0, 1]),
            Vector3([-1, 1, -1]),
            Vector3([-1, 1, 0]),
            Vector3([-1, 1, 1]),
            
            Vector3([0, -1, -1]),
            Vector3([0, -1, 0]),
            Vector3([0, -1, 1]),
            Vector3([0, 0, -1]),
            // no zero vector
            Vector3([0, 0, 1]),
            Vector3([0, 1, -1]),
            Vector3([0, 1, 0]),
            Vector3([0, 1, 1]),
            
            Vector3([1, -1, -1]),
            Vector3([1, -1, 0]),
            Vector3([1, -1, 1]),
            Vector3([1, 0, -1]),
            Vector3([1, 0, 0]),
            Vector3([1, 0, 1]),
            Vector3([1, 1, -1]),
            Vector3([1, 1, 0]),
            Vector3([1, 1, 1]),
        ])
    }
    
    func testAdjacentLengths() {
        let a = Vector2.adjacents(orthogonalOnly: true, includingSelf: false, length: 5)
        XCTAssertEqual(a, [
            Vector2([-2, 0]),
            Vector2([-1, 0]),
            
            Vector2([0, -2]),
            Vector2([0, -1]),
            
            Vector2([0, 1]),
            Vector2([0, 2]),
            
            Vector2([1, 0]),
            Vector2([2, 0]),
        ])
    }
    
}
