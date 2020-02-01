import Foundation

extension FileHandle {
    func write(string: String) {
        write(string.data(using: .utf8)!)
    }
}

/// A command line interface showing a timer.
public class TimerViewCLI {
    let output: FileHandle
    var timerViewModel: TimerViewModelType?
    let outputLength: Int = 60
    var sleepTime: TimeInterval = 1
    let intervalBeforePuttingDisplayToSleep: TimeInterval = 10

    // MARK: - Creating a timer.

    /// Creates a new instance of a timer.
    ///
    /// - Parameter output: a `FileHandle` where the timer will be written out (most likely `FileHandle.standardOutput`)
    public init(output: FileHandle) {
        self.output = output
    }

    // MARK: - Starting the timer

    /// Starts the timer for the specified duration.
    ///
    /// - Parameter pomodoro: the description of the Pomodoro.
    public func start(pomodoro: PomodoroDescription) {
        let timerViewModel = TimerViewModel(timeInterval: pomodoro.duration)
        self.timerViewModel = timerViewModel

        Hook.didStart.execute(completionHandler: hookCompletionHandler)

        output.write(string: "🍅 from \(pomodoro.formattedStartDate) to \(pomodoro.formattedEndDate)\n")
        sleepTime = pomodoro.duration / TimeInterval(outputLength)
        while !timerViewModel.outputs.progress.isFinished {
            outputLine(for: timerViewModel.outputs.progress.fractionCompleted)
            Thread.sleep(forTimeInterval: sleepTime)
        }
        outputLine(for: 1.0)
        output.write(string: "\nPomodoro ended\n")

        Hook.didFinish.execute(completionHandler: hookCompletionHandler)
        LogWriter().writeLog(pomodoroDescription: pomodoro)

        exit(EXIT_SUCCESS)
    }

    private func outputLine(for fractionCompleted: Double) {
        let completedChars = Int(fractionCompleted * Double(outputLength))
        let remainingChars = outputLength - completedChars
        let completedString = String(repeatElement("#", count: completedChars))
        let remainingString = String(repeatElement(".", count: remainingChars))
        output.write(string: "[\(completedString)\(remainingString)]\r")
    }

    private func hookCompletionHandler(result: Result<Void, HookError>) {
        if case let .failure(error) = result {
            switch error {
            case .noExecutableFileAtPath:
                output.write(string: "\n💡 Did you know you can configure hooks for pomodoros? Check the README.\n")
            default:
                output.write(string: "\n☹️ The pomodoro hook failed executing.\n")
            }
        }
        #if DEBUG
            if case .success = result {
                debugPrint("✌️ Hook completed successfully.")
            }
        #endif
    }
}
