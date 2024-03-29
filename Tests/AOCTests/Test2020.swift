//
//  Test2020.swift
//  AOCTests
//
//  Created by Dave DeLong on 11/15/20.
//  Copyright © 2020 Dave DeLong. All rights reserved.
//

import XCTest
@testable import AOC2020

class Test2020: XCTestCase {

	func testDay1() async throws {
		let d = Day1()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, "55776")
		XCTAssertEqual(p2, "223162626")
	}

	func testDay2() async throws {
		let d = Day2()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 548)
		XCTAssertEqual(p2, 502)
	}

	func testDay3() async throws {
		let d = Day3()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 272)
		XCTAssertEqual(p2, 3898725600)
	}

	func testDay4() async throws {
		let d = Day4()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 213)
		XCTAssertEqual(p2, 147)
	}

	func testDay5() async throws {
		let d = Day5()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 890)
		XCTAssertEqual(p2, 651)
	}

	func testDay6() async throws {
		let d = Day6()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, "6885")
		XCTAssertEqual(p2, "3550")
	}

	func testDay7() async throws {
		let d = Day7()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 142)
		XCTAssertEqual(p2, 10219)
	}

	func testDay8() async throws {
		let d = Day8()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 2014)
		XCTAssertEqual(p2, 2251)
	}

	func testDay9() async throws {
		let d = Day9()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 27911108)
		XCTAssertEqual(p2, 4023754)
	}

	func testDay10() async throws {
		let d = Day10()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 2760)
		XCTAssertEqual(p2, 13816758796288)
	}

	func testDay11() async throws {
		let d = Day11()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 2108)
		XCTAssertEqual(p2, 1897)
	}

	func testDay12() async throws {
		let d = Day12()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 1533)
		XCTAssertEqual(p2, 25235)
	}

	func testDay13() async throws {
		let d = Day13()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, "1835")
		XCTAssertEqual(p2, "247086664214628")
	}

	func testDay14() async throws {
		let d = Day14()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 16003257187056)
		XCTAssertEqual(p2, 3219837697833)
	}

	func testDay15() async throws {
		let d = Day15()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, "447")
		XCTAssertEqual(p2, "11721679")
	}

	func testDay16() async throws {
		let d = Day16()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 19093)
		XCTAssertEqual(p2, 5311123569883)
	}

	func testDay17() async throws {
		let d = Day17()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 298)
		XCTAssertEqual(p2, 1792)
	}

	func testDay18() async throws {
		let d = Day18()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 11004703763391)
		XCTAssertEqual(p2, 290726428573651)
	}

	func testDay19() async throws {
		let d = Day19()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 239)
		XCTAssertEqual(p2, 405)
	}

	func testDay20() async throws {
		let d = Day20()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, "29125888761511")
		XCTAssertEqual(p2, "2219")
	}

	func testDay21() async throws {
		let d = Day21()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 1882)
		XCTAssertEqual(p2, "xgtj,ztdctgq,bdnrnx,cdvjp,jdggtft,mdbq,rmd,lgllb")
	}

	func testDay22() async throws {
		let d = Day22()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 32677)
		XCTAssertEqual(p2, 33661)
	}

	func testDay23() async throws {
		let d = Day23()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, "32658947")
		XCTAssertEqual(p2, "683486010900")
	}

	func testDay24() async throws {
		let d = Day24()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, 326)
		XCTAssertEqual(p2, 3979)
	}

	func testDay25() async throws {
		let d = Day25()
		let (p1, p2) = try await d.run()

		XCTAssertEqual(p1, "17980581")
		XCTAssertEqual(p2, "")
	}
}
