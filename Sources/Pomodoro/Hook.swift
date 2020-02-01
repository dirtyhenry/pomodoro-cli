import Foundation

/// A hook is a moment of a pomodoro lifecyle where a script can be executed.
enum Hook {
    case didStart
    case didFinish
}

extension Hook {
    // MARK: - Script Support of Hooks
    static let dotDirectoryName = ".pomodoro-cli"

    static let didStartScript = "didStart.sh"
    static let didFinishScript = "didFinish.sh"

    @available(OSX 10.12, *)
    private var scriptURL: URL {
        let dotDirectory = FileManager.default
            .homeDirectoryForCurrentUser
            .appendingPathComponent(Hook.dotDirectoryName)

        switch self {
        case .didStart:
            return dotDirectory.appendingPathComponent(Hook.didStartScript)
        case .didFinish:
            return dotDirectory.appendingPathComponent(Hook.didFinishScript)
        }
    }

    @available(OSX 10.12, *)
    private func canBeExecuted(completionHandler: (Bool, String?) -> Void) {
        _ = scriptURL.withUnsafeFileSystemRepresentation { cString in
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
        if #available(OSX 10.12, *) {
            self.canBeExecuted { executable, path in
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
        } else {
            completionHandler(.failure(.hookExecutionNotAvailable))
        }
    }
}

enum HookError: Error {
    case hookExecutedWithErroredTerminationStatus(Int32)
    case noExecutableFileAtPath(String?)
    case hookExecutionNotAvailable
}
