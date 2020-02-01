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

    let dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .medium
        return result
    }()

    // MARK: - Creating a timer.

    /// Creates a new instance of a timer.
    ///
    /// - Parameter output: a `FileHandle` where the timer will be written out (most likely `FileHandle.standardOutput`)
    public init(output: FileHandle) {
        self.output = output
    }

    // MARK: - Starting the timer

    /// Starts the timer for a duration described as a time interval string.
    ///
    /// - Parameter durationAsString: the duration of the timer. Two kinds of strings are supported:
    ///     * A string **with digits only** will be parsed as a number of **seconds**;
    ///     * A string **finishing with `m`** will be parsed as a number of **minutes**.
    ///     (example: `123` or `123m` or `123 m`)
    public func start(durationAsString: String) {
        do {
            start(duration: try TimeInterval.fromHumanReadableString(durationAsString))
        } catch {
            output.write(string: "Could not start the timer with interval \(durationAsString)")
        }
    }

    /// Starts the timer for the specified duration.
    ///
    /// - Parameter duration: the duration of the string. Two kinds of strings are supported:
    ///     * A string **with digits only** will be parsed as a number of **seconds**;
    ///     * A string **finishing with `m`** will be parsed as a number of **minutes**.
    ///     (example: `123` or `123m` or `123 m`)
    public func start(duration: TimeInterval) {
        let timerViewModel = TimerViewModel(timeInterval: duration)
        self.timerViewModel = timerViewModel

        Hook.didStart.execute(completionHandler: hookCompletionHandler)

        let beginning = dateFormatter.string(from: timerViewModel.outputs.startDate)
        let end = dateFormatter.string(from: timerViewModel.outputs.endDate)
        output.write(string: "🍅 from \(beginning) to \(end)\n")
        sleepTime = duration / TimeInterval(outputLength)
        while !timerViewModel.outputs.progress.isFinished {
            outputLine(for: timerViewModel.outputs.progress.fractionCompleted)
            Thread.sleep(forTimeInterval: sleepTime)
        }
        outputLine(for: 1.0)
        output.write(string: "\nTimer ended\n")

        Hook.didFinish.execute(completionHandler: hookCompletionHandler)

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
        switch result {
        case .success:
            debugPrint("✌️ Hook completed successfully.")
        case let .failure(error):
            switch error {
            case .noExecutableFileAtPath:
                output.write(string: "\n💡 Did you know you can configure hooks for pomodoros? Check the README.\n")
            default:
                output.write(string: "\n☹️ The pomodoro hook failed executing.\n")
            }
        }
    }
}
