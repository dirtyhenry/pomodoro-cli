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
    public func start(pomodoro: PomodoroDescription, shouldExitRightAway: Bool = false) {
        if !shouldExitRightAway {
            let timerViewModel = TimerViewModel(timeInterval: pomodoro.duration)
            self.timerViewModel = timerViewModel

            // Set up interrupt handling
            let semaphore = DispatchSemaphore(value: 0)
            let interruptHandler = InterruptHandler()
            interruptHandler.setup(semaphore: semaphore)

            Hook.didStart.execute(description: pomodoro, completionHandler: hookCompletionHandler)

            if pomodoro.isIndefinite {
                output.write(string: "🍅 from \(pomodoro.formattedStartDate) (indefinite - press Ctrl+C to finish)\n")
                sleepTime = 1.0 // Update every second for elapsed time display
            } else {
                output.write(string: "🍅 from \(pomodoro.formattedStartDate) to \(pomodoro.formattedEndDate)\n")
                sleepTime = pomodoro.duration / TimeInterval(outputLength)
            }

            var wasInterrupted = false
            // For indefinite pomodoros, loop forever until interrupted
            // For regular pomodoros, loop until finished or interrupted
            while pomodoro.isIndefinite || !timerViewModel.outputs.progress.isFinished {
                if pomodoro.isIndefinite {
                    // Show elapsed time for indefinite pomodoros
                    let elapsed = Date().timeIntervalSince(timerViewModel.outputs.startDate)
                    outputElapsedTime(elapsed: elapsed)
                } else {
                    // Show progress bar for regular pomodoros
                    outputLine(for: timerViewModel.outputs.progress.fractionCompleted)
                }

                // Wait with timeout - can be woken by interrupt or timeout
                let result = semaphore.wait(timeout: .now() + sleepTime)

                if result == .success {
                    // Woken by interrupt signal
                    wasInterrupted = true
                    break
                }
                // Otherwise, timeout occurred - continue normal progress
            }

            // Cancel interrupt handler
            interruptHandler.cancel()

            if wasInterrupted {
                // Handle interrupt - show menu and let user decide
                handleInterrupt(pomodoro: pomodoro, timerViewModel: timerViewModel)
                return
            }

            // Normal completion
            outputLine(for: 1.0)
            output.write(string: "\nPomodoro ended\n")
        }

        Hook.didFinish.execute(description: pomodoro, completionHandler: hookCompletionHandler)
        LogWriter().writeLog(pomodoroDescription: pomodoro)

        exit(EXIT_SUCCESS)
    }

    // MARK: - Interrupt Handling

    /// Handles an interrupt by showing a menu and processing user choice
    private func handleInterrupt(pomodoro: PomodoroDescription, timerViewModel: TimerViewModel) {
        // Clear the current line
        output.write(string: "\n")

        // Show menu
        output.write(string: "\nPomodoro interrupted!\n")
        output.write(string: "1) Exit without saving\n")
        output.write(string: "2) Save shortened pomodoro\n")
        output.write(string: "Choose (1 or 2): ")

        // Read user choice
        guard let input = readLine()?.trimmingCharacters(in: .whitespaces) else {
            exit(0)
        }

        switch input {
        case "1":
            // Exit without saving
            exit(0)

        case "2":
            // Save shortened pomodoro
            saveShortened(pomodoro: pomodoro, timerViewModel: timerViewModel)

        default:
            // Invalid input - show error and try again
            output.write(string: "Invalid choice. Please enter 1 or 2.\n")
            handleInterrupt(pomodoro: pomodoro, timerViewModel: timerViewModel)
        }
    }

    /// Saves a shortened pomodoro with actual elapsed time
    private func saveShortened(pomodoro: PomodoroDescription, timerViewModel: TimerViewModel) {
        // Calculate actual elapsed time
        let actualDuration = Date().timeIntervalSince(timerViewModel.outputs.startDate)

        // Create new pomodoro description with actual duration
        let shortenedPomodoro = PomodoroDescription(
            startDate: timerViewModel.outputs.startDate,
            duration: actualDuration,
            message: pomodoro.message
        )

        output.write(string: "\nSaving shortened pomodoro (actual duration: \(Int(actualDuration))s)\n")

        // Execute didFinish hook with actual times
        Hook.didFinish.execute(description: shortenedPomodoro, completionHandler: hookCompletionHandler)

        // Write to journal with actual times
        LogWriter().writeLog(pomodoroDescription: shortenedPomodoro)

        exit(EXIT_SUCCESS)
    }

    private func outputLine(for fractionCompleted: Double) {
        let completedChars = Int(fractionCompleted * Double(outputLength))
        let remainingChars = outputLength - completedChars
        let completedString = String(repeatElement("#", count: completedChars))
        let remainingString = String(repeatElement(".", count: remainingChars))
        output.write(string: "[\(completedString)\(remainingString)]\r")
    }

    /// Displays elapsed time for indefinite pomodoros
    private func outputElapsedTime(elapsed: TimeInterval) {
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        let seconds = Int(elapsed) % 60

        let timeString = if hours > 0 {
            String(format: "%dh %dm %ds", hours, minutes, seconds)
        } else if minutes > 0 {
            String(format: "%dm %ds", minutes, seconds)
        } else {
            String(format: "%ds", seconds)
        }

        output.write(string: "Running: \(timeString)...\r")
    }

    private func hookCompletionHandler(result: Result<URL, HookError>) {
        if case let .failure(error) = result {
            switch error {
            case .noExecutableFileAtPath:
                output.write(string: "\n💡 Did you know you can configure hooks for pomodoros? Check the README.\n")
            default:
                output.write(string: "\n☹️ The pomodoro hook failed executing.\n")
            }
        }
        #if DEBUG
            if case let .success(hookURL) = result {
                debugPrint("✌️ Hook completed successfully (location: \(hookURL).")
            }
        #endif
    }
}
