import Foundation
import Commander

func outputProgressBar(timeInterval: TimeInterval) {
    let output = FileHandle.standardOutput

    let startDate = Date()
    print("startDate: \(startDate)")
    let endDate = startDate.addingTimeInterval(timeInterval)
    print("endDate: \(endDate)")

    let stringLength: Int = 60
    let sleepTime = timeInterval / Double(stringLength) / 4
    print("sleepTime: \(sleepTime)")

    let progress = Progress(totalUnitCount: Int64(timeInterval))
    progress.completedUnitCount = 0
    while !progress.isFinished {
        let elapsedTime = Date().timeIntervalSince(startDate)
        progress.completedUnitCount = Int64(elapsedTime)
        let completedChars = Int(progress.fractionCompleted * Double(stringLength))
        let remainingChars = stringLength - completedChars

        let completedString = String(repeatElement("#", count: completedChars))
        let remainingString = String(repeatElement(".", count: remainingChars))
        output.write("\(completedString)\(remainingString)\r".data(using: .utf8)!)
        sleep(UInt32(sleepTime))
    }
    output.write("\nTimer ended\n".data(using: .utf8)!)
}

let main = command { (duration:Int) in
    let timeInterval = TimeInterval(duration * 60)
    outputProgressBar(timeInterval: timeInterval)
}

main.run()
