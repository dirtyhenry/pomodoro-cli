import Foundation

/// A hook is a moment of a pomodoro lifecyle where a script can be executed.
enum Hook {
    case didStart
    case didFinish
}

extension Hook {
    // MARK: - Script Support of Hooks

    static let didStartScript = "didStart.sh"
    static let didFinishScript = "didFinish.sh"

    private var scriptURL: URL {
        switch self {
        case .didStart:
            return Environment.dotDirectory.appendingPathComponent(Hook.didStartScript)
        case .didFinish:
            return Environment.dotDirectory.appendingPathComponent(Hook.didFinishScript)
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

    func execute(completionHandler: (Result<Void, HookError>) -> Void) {
        guard Environment.hooksOn else {
            return
        }

        canBeExecuted { executable, path in
            if executable, let path = path {
                let task = Process.launchedProcess(launchPath: path, arguments: [])
                task.waitUntilExit()
                let status = task.terminationStatus
                if status == 0 {
                    completionHandler(.success(()))
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
