// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pomodoro",
    platforms: [
        .macOS(.v10_12),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.1"),
        .package(url: "https://github.com/apple/swift-tools-support-core", from: "0.1.12")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "Pomodoro", dependencies: ["ArgumentParser", "SwiftToolsSupport"]),
        .target(name: "PomodoroCLI", dependencies: ["Pomodoro"]),
        .testTarget(name: "PomodoroTests", dependencies: ["Pomodoro"]),
    ]
)
