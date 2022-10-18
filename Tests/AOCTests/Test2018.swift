//
//  Test2018.swift
//  AOCTests
//
//  Created by Dave DeLong on 12/1/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import XCTest
@testable import AOC2018

class Test2018: XCTestCase {
    
    func testDay1() async throws {
        let (p1, p2) = try await Day1().run()
        
        XCTAssertEqual(p1, "580")
        XCTAssertEqual(p2, "81972")
    }
    
    func testDay2() async throws {
        let (p1, p2) = try await Day2().run()
        
        XCTAssertEqual(p1, "7688")
        XCTAssertEqual(p2, "lsrivmotzbdxpkxnaqmuwcchj")
    }
    
    func testDay3() async throws {
        let (p1, p2) = try await Day3().run()
        
        XCTAssertEqual(p1, "107663")
        XCTAssertEqual(p2, "1166")
    }
    
    func testDay4() async throws {
        let (p1, p2) = try await Day4().run()
        
        XCTAssertEqual(p1, "84834")
        XCTAssertEqual(p2, "53427")
    }
    
    func testDay5() async throws {
        let (p1, p2) = try await Day5().run()
        
        XCTAssertEqual(p1, "10384")
        XCTAssertEqual(p2, "5412")
    }
    
    func testDay6() async throws {
        let (p1, p2) = try await Day6().run()
        
        XCTAssertEqual(p1, "3660")
        XCTAssertEqual(p2, "35928")
    }
    
    func testDay7() async throws {
        let (p1, p2) = try await Day7().run()
        
        XCTAssertEqual(p1, "ADEFKLBVJQWUXCNGORTMYSIHPZ")
        XCTAssertEqual(p2, "1120")
    }
    
    func testDay8() async throws {
        let (p1, p2) = try await Day8().run()
        
        XCTAssertEqual(p1, "49426")
        XCTAssertEqual(p2, "40688")
    }
    
    func testDay9() async throws {
        let (p1, p2) = try await Day9().run()
        
        XCTAssertEqual(p1, "390093")
        XCTAssertEqual(p2, "3150377341")
    }
    
    func testDay10() async throws {
        let (p1, p2) = try await Day10().run()
        
        XCTAssertEqual(p1, "XPFXXXKL")
        XCTAssertEqual(p2, "10521")
    }
    
    func testDay11() async throws {
        let (p1, p2) = try await Day11().run()
        
        XCTAssertEqual(p1, "243,64")
        XCTAssertEqual(p2, "90,101,15")
    }
    
    func testDay12() async throws {
        let (p1, p2) = try await Day12().run()
        
        XCTAssertEqual(p1, "")
        XCTAssertEqual(p2, "")
    }
    
    func testDay13() async throws {
        let (p1, p2) = try await Day13().run()
        
        XCTAssertEqual(p1, "124,130")
        XCTAssertEqual(p2, "143,123")
    }
    
    func testDay14() async throws {
        let (p1, p2) = try await Day14().run()
        
        XCTAssertEqual(p1, "3410710325")
        XCTAssertEqual(p2, "20216138")
    }
    
    func testDay15() async throws {
        let (p1, p2) = try await Day15().run()
        
        XCTAssertEqual(p1, "195774")
        XCTAssertEqual(p2, "37272")
    }
    
    func testDay16() async throws {
        let (p1, p2) = try await Day16().run()
        
        XCTAssertEqual(p1, "517")
        XCTAssertEqual(p2, "667")
    }
    
    func testDay17() async throws {
        let (p1, p2) = try await Day17().run()
        
        XCTAssertEqual(p1, "29802")
        XCTAssertEqual(p2, "24660")
    }
    
    func testDay18() async throws {
        let (p1, p2) = try await Day18().run()
        
        XCTAssertEqual(p1, "594712")
        XCTAssertEqual(p2, "203138")
    }
    
    func testDay19() async throws {
        let (p1, p2) = try await Day19().run()
        
        XCTAssertEqual(p1, "1836")
        XCTAssertEqual(p2, "12690000")
    }
    
    func testDay20() async throws {
        let (p1, p2) = try await Day20().run()
        
        XCTAssertEqual(p1, "3958")
        XCTAssertEqual(p2, "8566")
    }
    
    func testDay21() async throws {
        let (p1, p2) = try await Day21().run()
        
        XCTAssertEqual(p1, "16134795")
        XCTAssertEqual(p2, "14254292")
    }
    
    func testDay22() async throws {
        let (p1, p2) = try await Day22().run()
        
        XCTAssertEqual(p1, "11843")
        XCTAssertEqual(p2, "1078")
    }
    
    func testDay23() async throws {
        let (p1, p2) = try await Day23().run()
        
        XCTAssertEqual(p1, "297")
        XCTAssertEqual(p2, "126233088")
    }
    
    func testDay24() async throws {
        let (p1, p2) = try await Day24().run()
        
        XCTAssertEqual(p1, "10723")
        XCTAssertEqual(p2, "5120")
    }
    
    func testDay25() async throws {
        let (p1, p2) = try await Day25().run()
        
        XCTAssertEqual(p1, "359")
        XCTAssertEqual(p2, "")
    }

}
