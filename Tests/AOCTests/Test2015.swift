//
//  Test2015.swift
//  AOCTests
//
//  Created by Dave DeLong on 12/8/18.
//  Copyright © 2015 Dave DeLong. All rights reserved.
//

import XCTest
@testable import AOC2015

class Test2015: XCTestCase {
    
    func testDay1() async throws {
        let (p1, p2) = try await Day1().run()
        
        XCTAssertEqual(p1, "74")
        XCTAssertEqual(p2, "1795")
    }
    
    func testDay2() async throws {
        let (p1, p2) = try await Day2().run()
        
        XCTAssertEqual(p1, "1606483")
        XCTAssertEqual(p2, "3842356")
    }
    
    func testDay3() async throws {
        let (p1, p2) = try await Day3().run()
        
        XCTAssertEqual(p1, "2565")
        XCTAssertEqual(p2, "2639")
    }
    
    func testDay4() async throws {
        let (p1, p2) = try await Day4().run()
        
        XCTAssertEqual(p1, "117946")
        XCTAssertEqual(p2, "3938038")
    }
    
    func testDay5() async throws {
        let (p1, p2) = try await Day5().run()
        
        XCTAssertEqual(p1, "255")
        XCTAssertEqual(p2, "55")
    }
    
    func testDay6() async throws {
        let (p1, p2) = try await Day6().run()
        
        XCTAssertEqual(p1, "377891")
        XCTAssertEqual(p2, "14110788")
    }
    
    func testDay7() async throws {
        let (p1, p2) = try await Day7().run()
        
        XCTAssertEqual(p1, "956")
        XCTAssertEqual(p2, "40149")
    }
    
    func testDay8() async throws {
        let (p1, p2) = try await Day8().run()
        
        XCTAssertEqual(p1, "1342")
        XCTAssertEqual(p2, "2074")
    }
    
    func testDay9() async throws {
        let (p1, p2) = try await Day9().run()
        
        XCTAssertEqual(p1, "251")
        XCTAssertEqual(p2, "898")
    }
    
    func testDay10() async throws {
        let (p1, p2) = try await Day10().run()
        
        XCTAssertEqual(p1, "492982")
        XCTAssertEqual(p2, "6989950")
    }
    
    func testDay11() async throws {
        let (p1, p2) = try await Day11().run()
        
        XCTAssertEqual(p1, "hepxxyzz")
        XCTAssertEqual(p2, "heqaabcc")
    }
    
    func testDay12() async throws {
        let (p1, p2) = try await Day12().run()
        
        XCTAssertEqual(p1, "191164")
        XCTAssertEqual(p2, "87842")
    }
    
    func testDay13() async throws {
        let (p1, p2) = try await Day13().run()
        
        XCTAssertEqual(p1, "733")
        XCTAssertEqual(p2, "725")
    }
    
    func testDay14() async throws {
        let (p1, p2) = try await Day14().run()
        
        XCTAssertEqual(p1, "2640")
        XCTAssertEqual(p2, "1102")
    }
    
    func testDay15() async throws {
        let (p1, p2) = try await Day15().run()
        
        XCTAssertEqual(p1, "222870")
        XCTAssertEqual(p2, "117936")
    }
    
    func testDay16() async throws {
        let (p1, p2) = try await Day16().run()
        
        XCTAssertEqual(p1, "103")
        XCTAssertEqual(p2, "405")
    }
    
    func testDay17() async throws {
        let (p1, p2) = try await Day17().run()
        
        XCTAssertEqual(p1, "654")
        XCTAssertEqual(p2, "57")
    }
    
    func testDay18() async throws {
        let (p1, p2) = try await Day18().run()
        
        XCTAssertEqual(p1, "1061")
        XCTAssertEqual(p2, "1006")
    }
    
    func testDay19() async throws {
        let (p1, p2) = try await Day19().run()
        
        XCTAssertEqual(p1, "535")
        XCTAssertEqual(p2, "212")
    }
    
    func testDay20() async throws {
        let (p1, p2) = try await Day20().run()
        
        XCTAssertEqual(p1, "786240")
        XCTAssertEqual(p2, "831600")
    }
    
    func testDay21() async throws {
        let (p1, p2) = try await Day21().run()
        
        XCTAssertEqual(p1, "111")
        XCTAssertEqual(p2, "188")
    }
    
    func testDay22() async throws {
        let (p1, p2) = try await Day22().run()
        
        XCTAssertEqual(p1, "1269")
        XCTAssertEqual(p2, "1309")
    }
    
    func testDay23() async throws {
        let (p1, p2) = try await Day23().run()
        
        XCTAssertEqual(p1, "170")
        XCTAssertEqual(p2, "247")
    }
    
    func testDay24() async throws {
        let (p1, p2) = try await Day24().run()
        
        XCTAssertEqual(p1, 10439961859)
        XCTAssertEqual(p2, 72050269)
    }
    
    func testDay25() async throws {
        let (p1, p2) = try await Day25().run()
        
        XCTAssertEqual(p1, 19980801)
        XCTAssertEqual(p2, 0)
    }
    
}
