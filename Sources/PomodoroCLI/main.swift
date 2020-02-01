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
        do {
            var pomodoroMessage: String? = message
            if pomodoroMessage == nil {
                pomodoroMessage = Input.readLine(prompt: "\u{001B}[32m💁‍♀️ What’s the intent of this pomodoro?\u{001B}[m\n")
            }

            let durationAsTimeInterval = try TimeInterval.fromHumanReadableString(duration ?? durationDefault)

            let pomodoro = PomodoroDescription(duration: durationAsTimeInterval, message: pomodoroMessage)
            TimerViewCLI(output: FileHandle.standardOutput).start(pomodoro: pomodoro)
        } catch {
            print("Could not start the timer with interval \(String(describing: duration))")
        }
    }
}

let cli = CLI(singleCommand: PomodoroCommand())
cli.goAndExit()
