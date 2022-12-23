//
//  Test2022.swift
//  AOCTests
//
//  Created by Dave DeLong on 10/12/22.
//  Copyright © 2022 Dave DeLong. All rights reserved.
//

import XCTest
@testable import AOC2022

class Test2022: XCTestCase {

    func testDay1() async throws {
        let d = Day1()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 70296)
        XCTAssertEqual(p2, 205381)
    }

    func testDay2() async throws {
        let d = Day2()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 13526)
        XCTAssertEqual(p2, 14204)
    }

    func testDay3() async throws {
        let d = Day3()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 7903)
        XCTAssertEqual(p2, 2548)
    }

    func testDay4() async throws {
        let d = Day4()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 536)
        XCTAssertEqual(p2, 845)
    }

    func testDay5() async throws {
        let d = Day5()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, "BZLVHBWQF")
        XCTAssertEqual(p2, "TDGJQTZSL")
    }

    func testDay6() async throws {
        let d = Day6()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 1855)
        XCTAssertEqual(p2, 3256)
    }

    func testDay7() async throws {
        let d = Day7()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 1501149)
        XCTAssertEqual(p2, 10096985)
    }

    func testDay8() async throws {
        let d = Day8()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 1672)
        XCTAssertEqual(p2, 327180)
    }

    func testDay9() async throws {
        let d = Day9()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 6067)
        XCTAssertEqual(p2, 2471)
    }

    func testDay10() async throws {
        let d = Day10()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 14720)
        XCTAssertEqual(p2, "FZBPBFZF")
    }

    func testDay11() async throws {
        let d = Day11()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 124608)
        XCTAssertEqual(p2, 25590400731)
    }

    func testDay12() async throws {
        let d = Day12()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 383)
        XCTAssertEqual(p2, 377)
    }

    func testDay13() async throws {
        let d = Day13()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 6272)
        XCTAssertEqual(p2, 22288)
    }

    func testDay14() async throws {
        let d = Day14()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 873)
        XCTAssertEqual(p2, 24813)
    }

    func testDay15() async throws {
        let d = Day15()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 5181556)
        XCTAssertEqual(p2, 12817603219131)
    }

    func testDay16() async throws {
        let d = Day16()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 1828)
        XCTAssertEqual(p2, 0)
    }

    func testDay17() async throws {
        let d = Day17()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 3102)
        XCTAssertEqual(p2, 0)
    }

    func testDay18() async throws {
        let d = Day18()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 4628)
        XCTAssertEqual(p2, 2582)
    }

    func testDay19() async throws {
        let d = Day19()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, "")
        XCTAssertEqual(p2, "")
    }

    func testDay20() async throws {
        let d = Day20()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 16533)
        XCTAssertEqual(p2, "")
    }

    func testDay21() async throws {
        let d = Day21()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 10037517593724)
        XCTAssertEqual(p2, 3272260914328)
    }

    func testDay22() async throws {
        let d = Day22()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 133174)
        XCTAssertEqual(p2, "")
    }

    func testDay23() async throws {
        let d = Day23()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, 3931)
        XCTAssertEqual(p2, 944)
    }

    func testDay24() async throws {
        let d = Day24()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, "")
        XCTAssertEqual(p2, "")
    }

    func testDay25() async throws {
        let d = Day25()
        let (p1, p2) = try await d.run()

        XCTAssertEqual(p1, "")
        XCTAssertEqual(p2, "")
    }
}
