import Foundation

enum TimeIntervalConversionError: Error {
    case emptyInput
    case unsupportedFormat
}

extension TimeInterval {
    // MARK: - Creating a time internal from a human readable expression.

    /// Interprets a duration from a human readable string.
    ///
    /// Two kinds of strings are supported:
    ///
    /// * A string **with digits only** will be parsed as a number of **seconds** (example: `123`);
    /// * A string **finishing with `m`** will be parsed as a number of **minutes** (example: `123m` or `123 m`).
    public static func fromHumanReadableString(_ string: String) throws -> TimeInterval {
        let normalizedInput = string.replacingOccurrences(of: " ", with: "")

        guard let lastChar = normalizedInput.last else {
            throw TimeIntervalConversionError.emptyInput
        }

        switch lastChar {
        case "m":
            guard let minutesDuration = Double(normalizedInput.dropLast()) else {
                throw TimeIntervalConversionError.unsupportedFormat
            }
            return minutesDuration * Double(60.0)
        default:
            guard let secondsDuration = Double(normalizedInput) else {
                throw TimeIntervalConversionError.unsupportedFormat
            }
            return secondsDuration
        }
    }
}
