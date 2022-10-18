//
//  Test2017.swift
//  AOCTests
//
//  Created by Dave DeLong on 12/1/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import XCTest
@testable import AOC2017

class Test2017: XCTestCase {

    func testDay1() async throws {
        let (p1, p2) = try await Day1().run()
        
        XCTAssertEqual(p1, "1343")
        XCTAssertEqual(p2, "1274")
    }
    
    func testDay2() async throws {
        let (p1, p2) = try await Day2().run()
        
        XCTAssertEqual(p1, "45972")
        XCTAssertEqual(p2, "326")
    }
    
    func testDay3() async throws {
        let (p1, p2) = try await Day3().run()
        
        XCTAssertEqual(p1, "475")
        XCTAssertEqual(p2, "279138")
    }
    
    func testDay4() async throws {
        let (p1, p2) = try await Day4().run()
        
        XCTAssertEqual(p1, 477)
        XCTAssertEqual(p2, 167)
    }
    
    func testDay5() async throws {
        let (p1, p2) = try await Day5().run()
        
        XCTAssertEqual(p1, "364539")
        XCTAssertEqual(p2, "27477714")
    }
    
    func testDay6() async throws {
        let (p1, p2) = try await Day6().run()
        
        XCTAssertEqual(p1, "3156")
        XCTAssertEqual(p2, "1610")
    }
    
    func testDay7() async throws {
        let (p1, p2) = try await Day7().run()
        
        XCTAssertEqual(p1, "dtacyn")
        XCTAssertEqual(p2, "521")
    }
    
    func testDay8() async throws {
        let (p1, p2) = try await Day8().run()
        
        XCTAssertEqual(p1, "3745")
        XCTAssertEqual(p2, "4644")
    }
    
    func testDay9() async throws {
        let (p1, p2) = try await Day9().run()
        
        XCTAssertEqual(p1, "21037")
        XCTAssertEqual(p2, "9495")
    }
    
    func testDay10() async throws {
        let (p1, p2) = try await Day10().run()
        
        XCTAssertEqual(p1, "62238")
        XCTAssertEqual(p2, "2b0c9cc0449507a0db3babd57ad9e8d8")
    }
    
    func testDay11() async throws {
        let (p1, p2) = try await Day11().run()
        
        XCTAssertEqual(p1, "794")
        XCTAssertEqual(p2, "1524")
    }
    
    func testDay12() async throws {
        let (p1, p2) = try await Day12().run()
        
        XCTAssertEqual(p1, "288")
        XCTAssertEqual(p2, "211")
    }
    
    func testDay13() async throws {
        let (p1, p2) = try await Day13().run()
        
        XCTAssertEqual(p1, "2688")
        XCTAssertEqual(p2, "3876272")
    }
    
    func testDay14() async throws {
        let (p1, p2) = try await Day14().run()
        
        XCTAssertEqual(p1, "8140")
        XCTAssertEqual(p2, "1182")
    }
    
    func testDay15() async throws {
        let (p1, p2) = try await Day15().run()
        
        XCTAssertEqual(p1, "609")
        XCTAssertEqual(p2, "253")
    }
    
    func testDay16() async throws {
        let (p1, p2) = try await Day16().run()
        
        XCTAssertEqual(p1, "pkgnhomelfdibjac")
        XCTAssertEqual(p2, "pogbjfihclkemadn")
    }
    
    func testDay17() async throws {
        let (p1, p2) = try await Day17().run()
        
        XCTAssertEqual(p1, "355")
        XCTAssertEqual(p2, "6154117")
    }
    
    func testDay18() async throws {
        let (p1, p2) = try await Day18().run()
        
        XCTAssertEqual(p1, "1187")
        XCTAssertEqual(p2, "5969")
    }
    
    func testDay19() async throws {
        let (p1, p2) = try await Day19().run()
        
        XCTAssertEqual(p1, "BPDKCZWHGT")
        XCTAssertEqual(p2, "17728")
    }
    
    func testDay20() async throws {
        let (p1, p2) = try await Day20().run()
        
        XCTAssertEqual(p1, "300")
        XCTAssertEqual(p2, "502")
    }
    
    func testDay21() async throws {
        let (p1, p2) = try await Day21().run()
        
        XCTAssertEqual(p1, "152")
        XCTAssertEqual(p2, "1956174")
    }
    
    func testDay22() async throws {
        let (p1, p2) = try await Day22().run()
        
        XCTAssertEqual(p1, "5246")
        XCTAssertEqual(p2, "2512059")
    }
    
    func testDay23() async throws {
        let (p1, p2) = try await Day23().run()
        
        XCTAssertEqual(p1, "9409")
        XCTAssertEqual(p2, "913")
    }
    
    func testDay24() async throws {
        let (p1, p2) = try await Day24().run()
        
        XCTAssertEqual(p1, "1906")
        XCTAssertEqual(p2, "1824")
    }
    
    func testDay25() async throws {
        let (p1, p2) = try await Day25().run()
        
        XCTAssertEqual(p1, "633")
        XCTAssertEqual(p2, "633")
    }

}
