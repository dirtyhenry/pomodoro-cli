import Foundation

struct Environment {
    static let dotDirectoryName = ".pomodoro-cli"

    static let dotDirectory = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent(dotDirectoryName)
    
    static let hooksOn = false
}
