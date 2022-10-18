//
//  Test2021.swift
//  AOCTests
//
//  Created by Dave DeLong on 11/25/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

import XCTest
@testable import AOC2021

class Test2021: XCTestCase {

    func testDay1() async throws {
        let (p1, p2) = try await Day1().run()

        XCTAssertEqual(p1, 1167)
        XCTAssertEqual(p2, 1130)
    }

    func testDay2() async throws {
        let (p1, p2) = try await Day2().run()

        XCTAssertEqual(p1, 1524750)
        XCTAssertEqual(p2, 1592426537)
    }

    func testDay3() async throws {
        let (p1, p2) = try await Day3().run()

        XCTAssertEqual(p1, 1307354)
        XCTAssertEqual(p2, 482500)
    }

    func testDay4() async throws {
        let (p1, p2) = try await Day4().run()

        XCTAssertEqual(p1, 11536)
        XCTAssertEqual(p2, 1284)
    }

    func testDay5() async throws {
        let (p1, p2) = try await Day5().run()

        XCTAssertEqual(p1, 7436)
        XCTAssertEqual(p2, 21104)
    }

    func testDay6() async throws {
        let (p1, p2) = try await Day6().run()

        XCTAssertEqual(p1, 356190)
        XCTAssertEqual(p2, 1617359101538)
    }

    func testDay7() async throws {
        let (p1, p2) = try await Day7().run()

        XCTAssertEqual(p1, 343468)
        XCTAssertEqual(p2, 96086265)
    }

    func testDay8() async throws {
        let (p1, p2) = try await Day8().run()

        XCTAssertEqual(p1, 310)
        XCTAssertEqual(p2, 915941)
    }

    func testDay9() async throws {
        let (p1, p2) = try await Day9().run()

        XCTAssertEqual(p1, 439)
        XCTAssertEqual(p2, 900900)
    }

    func testDay10() async throws {
        let (p1, p2) = try await Day10().run()

        XCTAssertEqual(p1, 344193)
        XCTAssertEqual(p2, 3241238967)
    }

    func testDay11() async throws {
        let (p1, p2) = try await Day11().run()

        XCTAssertEqual(p1, 1785)
        XCTAssertEqual(p2, 354)
    }

    func testDay12() async throws {
        let (p1, p2) = try await Day12().run()

        XCTAssertEqual(p1, 4912)
        XCTAssertEqual(p2, 150004)
    }

    func testDay13() async throws {
        let (p1, p2) = try await Day13().run()

        XCTAssertEqual(p1, 689)
        XCTAssertEqual(p2, "RLBCJGLU")
    }

    func testDay14() async throws {
        let (p1, p2) = try await Day14().run()

        XCTAssertEqual(p1, 3411)
        XCTAssertEqual(p2, 7477815755570)
    }

    func testDay15() async throws {
        let (p1, p2) = try await Day15().run()

        XCTAssertEqual(p1, 508)
        XCTAssertEqual(p2, 2872)
    }

    func testDay16() async throws {
        let (p1, p2) = try await Day16().run()

        XCTAssertEqual(p1, 893)
        XCTAssertEqual(p2, 4358595186090)
    }

    func testDay17() async throws {
        let (p1, p2) = try await Day17().run()

        XCTAssertEqual(p1, 15931)
        XCTAssertEqual(p2, 2555)
    }

    func testDay18() async throws {
        let (p1, p2) = try await Day18().run()

        XCTAssertEqual(p1, "4116")
        XCTAssertEqual(p2, "4638")
    }

    func testDay19() async throws {
        let (p1, p2) = try await Day19().run()

        XCTAssertEqual(p1, 378)
        XCTAssertEqual(p2, 13148)
    }

    func testDay20() async throws {
        let (p1, p2) = try await Day20().run()

        XCTAssertEqual(p1, 5619)
        XCTAssertEqual(p2, 20122)
    }

    func testDay21() async throws {
        let (p1, p2) = try await Day21().run()

        XCTAssertEqual(p1, 897798)
        XCTAssertEqual(p2, 48868319769358)
    }

    func testDay22() async throws {
        let (p1, p2) = try await Day22().run()

        XCTAssertEqual(p1, 589411)
        XCTAssertEqual(p2, 1130514303649907)
    }

    func testDay23() async throws {
        let (p1, p2) = try await Day23().run()

        XCTAssertEqual(p1, 18300)
        XCTAssertEqual(p2, 50190)
    }

    func testDay24() async throws {
        let (p1, p2) = try await Day24().run()

        XCTAssertEqual(p1, 92969593497992)
        XCTAssertEqual(p2, 81514171161381)
    }

    func testDay25() async throws {
        let (p1, p2) = try await Day25().run()

        XCTAssertEqual(p1, 360)
        XCTAssertEqual(p2, "")
    }
}
