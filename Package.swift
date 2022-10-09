// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Pomodoro",
    platforms: [
        .macOS(.v10_12),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.4"),
        .package(url: "https://github.com/apple/swift-tools-support-core", from: "0.2.7")
    ],
    targets: [
        .target(name: "Pomodoro", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core")
        ]),
        .target(name: "PomodoroCLI", dependencies: ["Pomodoro"]),
        .testTarget(name: "PomodoroTests", dependencies: ["Pomodoro"]),
    ]
)
