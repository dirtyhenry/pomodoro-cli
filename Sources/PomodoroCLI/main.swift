import Foundation
import Pomodoro
import SwiftCLI

let durationDefault: String = "25m"

class PomodoroCommand: Command {
    let name = "pomodoro-cli"
    let shortDescription = "CLI pomodoro"

    @Key("-d", "--duration", description: "The duration of the pomodoro in seconds (100) or in minutes (10m) (default to \(durationDefault))")
    var duration: String?

    @Key("-m", "--message", description: "The intent of the pomodoro (example: email zero)")
    var message: String?

    func execute() throws {
        var pomodoroMessage: String? = message
        if pomodoroMessage == nil {
            pomodoroMessage = Input.readLine(prompt: "What’s the intent of this pomodoro?")
        }

        TimerViewCLI(output: FileHandle.standardOutput).start(
            durationAsString: duration ?? durationDefault,
            message: message
        )
    }
}

let cli = CLI(singleCommand: PomodoroCommand())
cli.goAndExit()
