import Foundation

public class TimeIntervalFormatter {
    private let formatter: DateComponentsFormatter

    public init() {
        formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowedUnits = [.minute, .second]
    }

    public func string(from timeInterval: TimeInterval) -> String? {
        let components = DateComponents(second: Int(timeInterval))
        return formatter.string(from: components)
    }

    public func timeInterval(from timeIntervalString: String) -> TimeInterval? {
        let normalizedInput = timeIntervalString.replacingOccurrences(
            of: "[^0-9m]+",
            with: "",
            options: .regularExpression
        )

        switch normalizedInput.last {
        case .none:
            return nil
        case "m":
            guard let minutesDuration = Double(normalizedInput.dropLast()) else {
                return nil
            }
            return minutesDuration * Double(60.0)
        default:
            guard let secondsDuration = Double(normalizedInput) else {
                return nil
            }
            return secondsDuration
        }
    }
}
