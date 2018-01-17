//
//  TimerViewCLI.swift
//  pomodoro-cli
//
//  Created by Mickaël Floc'hlay on 06/11/2017.
//

import Foundation

extension FileHandle {
    func write(string: String) {
        self.write(string.data(using: .utf8)!)
    }
}


class TimerViewCLI {
    let output: FileHandle
    var timerViewModel: TimerViewModelType?
    let outputLength: Int = 60
    var sleepTime: UInt32 = 1

    let dateFormatter: DateFormatter

    init(output: FileHandle) {
        self.output = output
        self.dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium

    }

    func start(timeInterval: TimeInterval) {
        timerViewModel = TimerViewModel(timeInterval: timeInterval, fireHandler: {
            //...
        })

        output.write(string: "Timer launched at \(dateFormatter.string(from: timerViewModel!.outputs.startDate))\n")
        output.write(string: "Timer will fire at \(dateFormatter.string(from: timerViewModel!.outputs.endDate))\n")

        let notification = NSUserNotification()
        notification.title = "Title"
        notification.subtitle = "Subtitle"
        notification.informativeText = "informativeText"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.deliveryDate = timerViewModel!.outputs.endDate
        NSUserNotificationCenter.default.scheduleNotification(notification)

        sleepTime = UInt32(timeInterval / Double(outputLength))

        while !timerViewModel!.outputs.progress.isFinished {
            let progress = timerViewModel!.outputs.progress
            let completedChars = Int(progress.fractionCompleted * Double(outputLength))
            let remainingChars = outputLength - completedChars
            let completedString = String(repeatElement("#", count: completedChars))
            let remainingString = String(repeatElement(".", count: remainingChars))
            output.write(string: "\(completedString)\(remainingString)\r")
            sleep(sleepTime)
        }

        output.write(string: "\nTimer ended\n")

        exit(EXIT_SUCCESS)
    }
}
