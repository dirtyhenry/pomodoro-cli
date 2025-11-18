import Blocks
import Foundation

/// A hook is a moment of a pomodoro lifecyle where a script can be executed.
enum Hook {
    case didStart
    case didFinish
}

extension Hook {
    // MARK: - Script Support of Hooks

    static let didStartScript = "pomodoro-start.sh"
    static let didFinishScript = "pomodoro-finish.sh"

    private var scriptURL: URL {
        switch self {
        case .didStart:
            Environment.dotDirectory.appendingPathComponent(Hook.didStartScript)
        case .didFinish:
            Environment.dotDirectory.appendingPathComponent(Hook.didFinishScript)
        }
    }

    private func canBeExecuted(completionHandler: (Bool, String?) -> Void) {
        scriptURL.withUnsafeFileSystemRepresentation { cString in
            if let scriptPath = cString.map({ String(cString: $0) }) {
                if FileManager.default.isExecutableFile(atPath: scriptPath) {
                    completionHandler(true, scriptPath)
                    return
                }
            }
            completionHandler(false, nil)
        }
    }

    func execute(description: PomodoroDescription, completionHandler: (Result<URL, HookError>) -> Void) {
        guard Environment.hooksOn else {
            return
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        canBeExecuted { executable, path in
            if executable, let path {
                // For indefinite pomodoros, pass "indefinite" as end date
                let endDateString = description.isIndefinite ? "indefinite" : formatter.string(from: description.endDate)
                let durationString = description.isIndefinite ? "indefinite" : description.duration.description

                let task = Process.launchedProcess(launchPath: path, arguments: [
                    formatter.string(from: description.startDate),
                    endDateString,
                    durationString,
                    description.message ?? "n/a"
                ])
                task.waitUntilExit()
                let status = task.terminationStatus
                if status == 0 {
                    completionHandler(.success(self.scriptURL))
                } else {
                    completionHandler(.failure(.hookExecutedWithErroredTerminationStatus(status)))
                }
            } else {
                completionHandler(.failure(.noExecutableFileAtPath(path)))
            }
        }
    }
}

enum HookError: Error {
    case hookExecutedWithErroredTerminationStatus(Int32)
    case noExecutableFileAtPath(String?)
}
