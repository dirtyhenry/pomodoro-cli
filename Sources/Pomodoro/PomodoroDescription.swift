import Foundation

/// A data struct encapsulating a full description of a Pomodoro.
public struct PomodoroDescription {
    static let dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .medium
        return result
    }()

    // MARK: - Creating a pomodoro

    /// Creates a new pomodoro.
    /// - Parameters:
    ///     - duration: the duration of the pomodoro.
    ///     - message: a message describing the intent of the pomodoro.
    public init(duration: TimeInterval, message: String?) {
        startDate = Date()
        self.duration = duration
        self.message = message
    }

    /// Creates a pomodoro with a custom start date.
    /// - Parameters:
    ///     - startDate: the start date of the pomodoro.
    ///     - duration: the duration of the pomodoro.
    ///     - message: a message describing the intent of the pomodoro.
    public init(startDate: Date, duration: TimeInterval, message: String?) {
        self.startDate = startDate
        self.duration = duration
        self.message = message
    }

    let startDate: Date
    let duration: TimeInterval
    let message: String?

    /// Returns true if this is an indefinite pomodoro (runs until manually stopped)
    var isIndefinite: Bool {
        duration.isInfinite
    }

    var endDate: Date {
        if isIndefinite {
            // Return far future date for indefinite pomodoros
            return Date.distantFuture
        }
        return startDate.addingTimeInterval(duration)
    }

    var formattedStartDate: String {
        PomodoroDescription.dateFormatter.string(from: startDate)
    }

    var formattedEndDate: String {
        if isIndefinite {
            return "indefinite"
        }
        return PomodoroDescription.dateFormatter.string(from: endDate)
    }
}

extension PomodoroDescription: CustomStringConvertible {
    /// The description of the Pomodoro, as logged in the journal.
    public var description: String {
        let lines = [
            "-",
            "  - startDate: \(formattedStartDate)",
            "  - endDate: \(formattedEndDate)",
            "  - message: \(message ?? "n/a")"
        ]
        return lines.joined(separator: "\n").appending("\n")
    }
}
