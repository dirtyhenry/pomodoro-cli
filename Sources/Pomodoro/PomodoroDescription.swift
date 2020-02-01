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

    let startDate: Date
    let duration: TimeInterval
    let message: String?

    var endDate: Date {
        return startDate.addingTimeInterval(duration)
    }

    var formattedStartDate: String {
        return PomodoroDescription.dateFormatter.string(from: startDate)
    }

    var formattedEndDate: String {
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
            "  - message: \(message ?? "n/a")",
        ]
        return lines.joined(separator: "\n").appending("\n")
    }
}
