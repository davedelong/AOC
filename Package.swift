// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "Advent of Code",
    platforms: [.macOS(.v11)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "advent", targets: ["advent"]),
        .library(name: "AOC", targets: ["AOC"]),
        .library(name: "AOCCore", targets: ["AOCCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "swift-collections", url: "git@github.com:apple/swift-collections.git", from: "1.0.2"),
        .package(name: "swift-algorithms", url: "git@github.com:apple/swift-algorithms.git", from: "0.0.2"),
        .package(name: "MathParser", url: "git@github.com:davedelong/DDMathParser.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "advent", dependencies: ["AOC"]),
        
        .target(name: "AOC", dependencies: ["AOCCore", "AOC2021", "AOC2020", "AOC2019", "AOC2018", "AOC2017", "AOC2016", "AOC2015"]),
        
        .target(name: "AOC2021", dependencies: ["AOCCore"], exclude: inputFiles(for: 2021)),
        .target(name: "AOC2020", dependencies: ["AOCCore", "MathParser"], exclude: inputFiles(for: 2020)),
        .target(name: "AOC2019", dependencies: ["AOCCore"], exclude: inputFiles(for: 2019)),
        .target(name: "AOC2018", dependencies: ["AOCCore"], exclude: inputFiles(for: 2018)),
        .target(name: "AOC2017", dependencies: ["AOCCore"], exclude: inputFiles(for: 2017)),
        .target(name: "AOC2016", dependencies: ["AOCCore"], exclude: inputFiles(for: 2016)),
        .target(name: "AOC2015", dependencies: ["AOCCore"], exclude: inputFiles(for: 2015)),
        
        .target(name: "AOCCore", dependencies: [
            .product(name: "Algorithms", package: "swift-algorithms"),
            .product(name: "Collections", package: "swift-collections")
        ]),
        
        .testTarget(name: "AOCTests", dependencies: ["AOC"]),
        .testTarget(name: "AOCCoreTests", dependencies: ["AOCCore"])
    ]
)

func inputFiles(for year: Int) -> Array<String> {
    let sourceDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent()
    return (1...25).compactMap { day in
        let fragment = "Day \(day)/input.txt"
        let path = sourceDirectory.appendingPathComponent("Sources/AOC\(year)/\(fragment)")
        if FileManager.default.fileExists(atPath: path.path) { return fragment }
        return nil
    }
}
