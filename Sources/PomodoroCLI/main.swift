import ArgumentParser
import Foundation
import Pomodoro

/// Terminal color choices.
public enum TerminalColor {
    case noColor

    case red
    case green
    case yellow
    case cyan

    case white
    case black
    case gray

    /// Returns the color code which can be prefixed on a string to display it in that color.
    fileprivate var string: String {
        switch self {
            case .noColor: return ""
            case .red: return "\u{001B}[31m"
            case .green: return "\u{001B}[32m"
            case .yellow: return "\u{001B}[33m"
            case .cyan: return "\u{001B}[36m"
            case .white: return "\u{001B}[37m"
            case .black: return "\u{001B}[30m"
            case .gray: return "\u{001B}[30;1m"
        }
    }
}

/// Code to end any currently active wrapping.
private let resetString = "\u{001B}[0m"

struct PomodoroCLI: ParsableCommand {
    @Option(name: .shortAndLong, help: "The duration of the pomodoro in seconds (100) or in minutes (10m)")
    var duration: String = "25m"

    @Option(name: .shortAndLong, help: "The intent of the pomodoro (example: email zero)")
    var message: String?

    func run() throws {
        do {
            let pomodoroMessage: String

            if let message = self.message {
                pomodoroMessage = message
            } else {
                print("\(TerminalColor.green.string)💁‍♀️ What is the intent of this pomodoro?\(resetString)")
                pomodoroMessage = readLine() ?? ""
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
