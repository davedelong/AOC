//
//  Test2019.swift
//  AOCTests
//
//  Created by Dave DeLong on 12/8/18.
//  Copyright © 2019 Dave DeLong. All rights reserved.
//

import XCTest
@testable import AOC2019

class Test2019: XCTestCase {
    
    func testDay1() async throws {
        let (p1, p2) = try await Day1().run()
        
        XCTAssertEqual(p1, "3266516")
        XCTAssertEqual(p2, "4896902")
    }
    
    func testDay2() async throws {
        let (p1, p2) = try await Day2().run()
        
        XCTAssertEqual(p1, "2894520")
        XCTAssertEqual(p2, "9342")
    }
    
    func testDay3() async throws {
        let (p1, p2) = try await Day3().run()
        
        XCTAssertEqual(p1, "860")
        XCTAssertEqual(p2, "9238")
    }
    
    func testDay4() async throws {
        let (p1, p2) = try await Day4().run()
        
        XCTAssertEqual(p1, "1640")
        XCTAssertEqual(p2, "1126")
    }
    
    func testDay5() async throws {
        let (p1, p2) = try await Day5().run()
        
        XCTAssertEqual(p1, "11049715")
        XCTAssertEqual(p2, "2140710")
    }
    
    func testDay6() async throws {
        let (p1, p2) = try await Day6().run()
        
        XCTAssertEqual(p1, "261306")
        XCTAssertEqual(p2, "382")
    }
    
    func testDay7() async throws {
        let (p1, p2) = try await Day7().run()
        
        XCTAssertEqual(p1, "67023")
        XCTAssertEqual(p2, "7818398")
    }
    
    func testDay8() async throws {
        let (p1, p2) = try await Day8().run()
        
        XCTAssertEqual(p1, "2032")
        XCTAssertEqual(p2, "CFCUG")
    }
    
    func testDay9() async throws {
        let (p1, p2) = try await Day9().run()
        
        XCTAssertEqual(p1, "3497884671")
        XCTAssertEqual(p2, "46470")
    }
    
    func testDay10() async throws {
        let (p1, p2) = try await Day10().run()
        
        XCTAssertEqual(p1, "282")
        XCTAssertEqual(p2, "1008")
    }
    
    func testDay11() async throws {
        let (p1, p2) = try await Day11().run()
        
        XCTAssertEqual(p1, "1885")
        XCTAssertEqual(p2, "BFEAGHAF")
    }
    
    func testDay12() async throws {
        let (p1, p2) = try await Day12().run()
        
        XCTAssertEqual(p1, "12070")
        XCTAssertEqual(p2, "500903629351944")
    }
    
    func testDay13() async throws {
        let (p1, p2) = try await Day13().run()
        
        XCTAssertEqual(p1, "242")
        XCTAssertEqual(p2, "11641")
    }
    
    func testDay14() async throws {
        let (p1, p2) = try await Day14().run()
        
        XCTAssertEqual(p1, "143173")
        XCTAssertEqual(p2, "8845261")
    }
    
    func testDay15() async throws {
        let (p1, p2) = try await Day15().run()
        
        XCTAssertEqual(p1, "77038830")
        XCTAssertEqual(p2, "28135104")
    }
    
    func testDay16() async throws {
        let (p1, p2) = try await Day16().run()
        
        XCTAssertEqual(p1, "77038830")
        XCTAssertEqual(p2, "28135104")
    }
    
    func testDay17() async throws {
        let (p1, p2) = try await Day17().run()
        
        XCTAssertEqual(p1, "6000")
        XCTAssertEqual(p2, "807320")
    }
    
    func testDay18() async throws {
        let (p1, p2) = try await Day18().run()
        
        XCTAssertEqual(p1, "4620")
        XCTAssertEqual(p2, "1564")
    }
    
    func testDay19() async throws {
        let (p1, p2) = try await Day19().run()
        
        XCTAssertEqual(p1, "129")
        XCTAssertEqual(p2, "14040699")
    }
    
    func testDay20() async throws {
        let (p1, p2) = try await Day20().run()
        
        XCTAssertEqual(p1, "498")
        XCTAssertEqual(p2, "5564")
    }
    
    func testDay21() async throws {
        let (p1, p2) = try await Day21().run()
        
        XCTAssertEqual(p1, "19358262")
        XCTAssertEqual(p2, "1142686742")
    }
    
    func testDay22() async throws {
        let (p1, p2) = try await Day22().run()
        
        XCTAssertEqual(p1, "2558")
        XCTAssertEqual(p2, "")
    }
    
    func testDay23() async throws {
        let (p1, p2) = try await Day23().run()
        
        XCTAssertEqual(p1, "")
        XCTAssertEqual(p2, "")
    }
    
    func testDay24() async throws {
        let (p1, p2) = try await Day24().run()
        
        XCTAssertEqual(p1, "")
        XCTAssertEqual(p2, "")
    }
    
    func testDay25() async throws {
        let (p1, p2) = try await Day25().run()
        
        XCTAssertEqual(p1, "")
        XCTAssertEqual(p2, "")
    }
    
}
