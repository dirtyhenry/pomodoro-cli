import ArgumentParser
import Blocks
import Foundation
import Pomodoro

@main
struct PomodoroCLI: ParsableCommand {
    @Option(name: .shortAndLong, help: "The duration of the pomodoro in seconds (100) or in minutes (10m)")
    var duration: String = "25m"

    @Option(name: .shortAndLong, help: "The intent of the pomodoro (example: email zero)")
    var message: String?

    func run() throws {
        installSignalHandler()
        guard let durationAsTimeInterval = TimeIntervalFormatter().timeInterval(from: duration) else {
            CLIUtils.write(message: "Invalid duration: \(duration)")
            return
        }

        let pomodoroMessage: String

        if let message = message {
            pomodoroMessage = message
        } else {
            CLIUtils.write(message: "💁‍♀️ What is the intent of this pomodoro?", foreground: .green)
            pomodoroMessage = readLine() ?? ""
        }

        let pomodoro = PomodoroDescription(duration: durationAsTimeInterval, message: pomodoroMessage)
        TimerViewCLI(output: FileHandle.standardOutput).start(pomodoro: pomodoro)
    }
    
    func installSignalHandler() {
        signal(SIGINT, SIG_IGN)
        let interruptSignalSource = DispatchSource.makeSignalSource(signal: SIGINT)

        // Add the event handler to the source
        interruptSignalSource.setEventHandler {
            // Restore default signal handling, which means killing the app
            signal(SIGINT, SIG_DFL)

            CLIUtils.write(message: "interrupted -- halting", foreground: .red)
//            Self.exit(withError: SimpleMessageError(message: "CTRL-C"))
        }
        interruptSignalSource.resume()
    }
}
