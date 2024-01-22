// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Pomodoro",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .executable(name: "pomodoro-cli", targets: ["PomodoroCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.4")
    ],
    targets: [
        .target(name: "Pomodoro", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),
        .executableTarget(name: "PomodoroCLI", dependencies: ["Pomodoro"]),
        .testTarget(name: "PomodoroTests", dependencies: ["Pomodoro"]),
    ]
)
