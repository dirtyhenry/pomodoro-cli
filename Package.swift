// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Pomodoro",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "pomodoro-cli", targets: ["PomodoroCLI"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/dirtyhenry/swift-blocks",
            branch: "main"
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.1.4"
        )
    ],
    targets: [
        .target(name: "Pomodoro", dependencies: [
            .product(name: "Blocks", package: "swift-blocks"),
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),
        .executableTarget(name: "PomodoroCLI", dependencies: ["Pomodoro"]),
        .testTarget(name: "PomodoroTests", dependencies: ["Pomodoro"]),
    ]
)
