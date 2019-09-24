//
//  Test2017.swift
//  AOCTests
//
//  Created by Dave DeLong on 12/1/18.
//  Copyright © 2018 Dave DeLong. All rights reserved.
//

import XCTest
import AOC

class Test2017: XCTestCase {

    func testDay1() {
        let d = Year2017.Day1()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "1343")
        XCTAssertEqual(p2, "1274")
    }
    
    func testDay2() {
        let d = Year2017.Day2()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "45972")
        XCTAssertEqual(p2, "326")
    }
    
    func testDay3() {
        let d = Year2017.Day3()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "475")
        XCTAssertEqual(p2, "279138")
    }
    
    func testDay4() {
        let d = Year2017.Day4()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "477")
        XCTAssertEqual(p2, "167")
    }
    
    func testDay5() {
        let d = Year2017.Day5()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "364539")
        XCTAssertEqual(p2, "27477714")
    }
    
    func testDay6() {
        let d = Year2017.Day6()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "3156")
        XCTAssertEqual(p2, "1610")
    }
    
    func testDay7() {
        let d = Year2017.Day7()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "dtacyn")
        XCTAssertEqual(p2, "521")
    }
    
    func testDay8() {
        let d = Year2017.Day8()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "3745")
        XCTAssertEqual(p2, "4644")
    }
    
    func testDay9() {
        let d = Year2017.Day9()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "21037")
        XCTAssertEqual(p2, "9495")
    }
    
    func testDay10() {
        let d = Year2017.Day10()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "62238")
        XCTAssertEqual(p2, "2b0c9cc0449507a0db3babd57ad9e8d8")
    }
    
    func testDay11() {
        let d = Year2017.Day11()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "794")
        XCTAssertEqual(p2, "1524")
    }
    
    func testDay12() {
        let d = Year2017.Day12()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "288")
        XCTAssertEqual(p2, "211")
    }
    
    func testDay13() {
        let d = Year2017.Day13()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "2688")
        XCTAssertEqual(p2, "3876272")
    }
    
    func testDay14() {
        let d = Year2017.Day14()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "8140")
        XCTAssertEqual(p2, "1182")
    }
    
    func testDay15() {
        let d = Year2017.Day15()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "609")
        XCTAssertEqual(p2, "253")
    }
    
    func testDay16() {
        let d = Year2017.Day16()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "pkgnhomelfdibjac")
        XCTAssertEqual(p2, "pogbjfihclkemadn")
    }
    
    func testDay17() {
        let d = Year2017.Day17()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "355")
        XCTAssertEqual(p2, "6154117")
    }
    
    func testDay18() {
        let d = Year2017.Day18()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "1187")
        XCTAssertEqual(p2, "5969")
    }
    
    func testDay19() {
        let d = Year2017.Day19()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "BPDKCZWHGT")
        XCTAssertEqual(p2, "17728")
    }
    
    func testDay20() {
        let d = Year2017.Day20()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "300")
        XCTAssertEqual(p2, "502")
    }
    
    func testDay21() {
        let d = Year2017.Day21()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "152")
        XCTAssertEqual(p2, "1956174")
    }
    
    func testDay22() {
        let d = Year2017.Day22()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "5246")
        XCTAssertEqual(p2, "2512059")
    }
    
    func testDay23() {
        let d = Year2017.Day23()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "9409")
        XCTAssertEqual(p2, "913")
    }
    
    func testDay24() {
        let d = Year2017.Day24()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "1906")
        XCTAssertEqual(p2, "1824")
    }
    
    func testDay25() {
        let d = Year2017.Day25()
        let (p1, p2) = d.run()
        
        XCTAssertEqual(p1, "633")
        XCTAssertEqual(p2, "633")
    }

}
