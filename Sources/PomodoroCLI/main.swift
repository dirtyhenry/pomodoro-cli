import ArgumentParser
import Foundation
import Pomodoro
import TSCBasic

struct PomodoroCLI: ParsableCommand {
    @Option(help: "The duration of the pomodoro in seconds (100) or in minutes (10m)")
    var duration: String = "25m"

    @Option(help: "The intent of the pomodoro (example: email zero)")
    var message: String?

    func run() throws {
        do {
            var pomodoroMessage: String? = message

            if pomodoroMessage == nil {
                let terminalController = TerminalController(stream: stdoutStream)
                terminalController?.write("💁‍♀️ What is the intent of this pomodoro?", inColor: .green)
                terminalController?.endLine()
                pomodoroMessage = readLine()
            }

            let durationAsTimeInterval = try TimeInterval.fromHumanReadableString(duration)

            let pomodoro = PomodoroDescription(duration: durationAsTimeInterval, message: pomodoroMessage)
            TimerViewCLI(output: FileHandle.standardOutput).start(pomodoro: pomodoro)
        } catch {
            print("Could not start the timer with interval \(String(describing: duration))")
        }
    }
}

PomodoroCLI.main()
