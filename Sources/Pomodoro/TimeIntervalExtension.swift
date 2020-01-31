import Foundation

enum TimeIntervalConversionError: Error {
    case emptyInput
    case unsupportedFormat
}

extension TimeInterval {
    static func fromHumanReadableString(_ string: String) throws -> TimeInterval {
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
