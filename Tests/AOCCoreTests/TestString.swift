//
//  File.swift
//  
//
//  Created by Dave DeLong on 10/12/22.
//

import XCTest
@testable import AOCCore

class TestStrings: XCTestCase {
    
    func testPadding() {
        
        let s1 = "abc".padding(toLength: 1, with: "a")
        XCTAssertEqual(s1, "abc")
        
        let s2 = "abc".padding(toLength: 4, with: "a")
        XCTAssertEqual(s2, "abca")
        
        let s3 = "abc".padding(toLength: 4, with: "ab")
        XCTAssertEqual(s3, "abca")
        
        let s4 = "abc".padding(toLength: 5, with: "ab")
        XCTAssertEqual(s4, "abcab")
        
        let s5 = "abc".padding(toLength: 6, with: "ab")
        XCTAssertEqual(s5, "abcaba")
        
    }
    
    func testPalindrome() {
        XCTAssertTrue("".isPalindrome)
        XCTAssertTrue("a".isPalindrome)
        XCTAssertTrue("aa".isPalindrome)
        XCTAssertTrue("aaa".isPalindrome)
        XCTAssertTrue("aa_aa".isPalindrome)
        
        XCTAssertTrue("abaaba".isPalindrome)
        
        XCTAssertFalse("abcbc".isPalindrome)
    }
}
