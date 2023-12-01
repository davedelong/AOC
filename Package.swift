// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "Advent of Code",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "advent", targets: ["advent"]),
        .library(name: "AOC", targets: ["AOC"]),
        .library(name: "AOCCore", targets: ["AOCCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "git@github.com:davedelong/ExtendedSwift.git", branch: "main"),
        .package(url: "git@github.com:davedelong/DDMathParser.git", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(name: "advent", dependencies: ["AOC"]),
        
        .target(name: "AOC", dependencies: ["AOCCore", "AOC2023", /*"AOC2022", "AOC2021", "AOC2020", "AOC2019", "AOC2018", "AOC2017", "AOC2016", "AOC2015"*/]),
        
        target(for: 2023),
        target(for: 2022),
        target(for: 2021),
        target(for: 2020),
        target(for: 2019),
        target(for: 2018),
        target(for: 2017),
        target(for: 2016),
        target(for: 2015),
        
        .target(name: "AOCCore", dependencies: [
            .product(name: "ExtendedSwift", package: "ExtendedSwift"),
            .product(name: "MathParser", package: "DDMathParser")
        ],
                swiftSettings: [
                    .unsafeFlags(["-enable-bare-slash-regex"])
                ]),
        
        .testTarget(name: "AOCTests", dependencies: ["AOC"]),
        .testTarget(name: "AOCCoreTests", dependencies: ["AOCCore"])
    ]
)

func target(for year: Int) -> Target {
    return .target(name: "AOC\(year)",
                   dependencies: ["AOCCore"],
                   exclude: inputFiles(for: year),
                   swiftSettings: [
                    .unsafeFlags(["-enable-bare-slash-regex"])
                   ])
}

func inputFiles(for year: Int) -> Array<String> {
    let sourceDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent()
    return (1...25).compactMap { day in
        let fragment = "Day \(day)/input.txt"
        let path = sourceDirectory.appendingPathComponent("Sources/AOC\(year)/\(fragment)")
        if FileManager.default.fileExists(atPath: path.path) { return fragment }
        return nil
    }
}
