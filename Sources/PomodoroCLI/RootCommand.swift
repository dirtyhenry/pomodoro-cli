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

    @Flag(name: .shortAndLong, help: "Exit right away (escape-hatch to run hooks only)")
    var catchUp: Bool = false

    func run() throws {
        guard let durationAsTimeInterval = TimeIntervalFormatter().timeInterval(from: duration) else {
            CLIUtils.write(message: "Invalid duration: \(duration)")
            return
        }

        let pomodoroMessage: String

        if let message {
            pomodoroMessage = message
        } else {
            CLIUtils.write(message: "💁‍♀️ What is the intent of this pomodoro?", foreground: .green)
            pomodoroMessage = readLine() ?? ""
        }

        let pomodoro = PomodoroDescription(duration: durationAsTimeInterval, message: pomodoroMessage)
        TimerViewCLI(output: FileHandle.standardOutput).start(pomodoro: pomodoro, shouldExitRightAway: catchUp)
    }
}
