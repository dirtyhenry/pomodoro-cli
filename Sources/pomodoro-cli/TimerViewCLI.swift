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
    var sleepTime: TimeInterval = 1
    let intervalBeforePuttingDisplayToSleep: TimeInterval = 10

    let dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .medium
        return result
    }()

    init(output: FileHandle) {
        self.output = output
    }

    func start(timeInterval: TimeInterval) {
        let timerViewModel = TimerViewModel(timeInterval: timeInterval, fireHandler: {
            //...
        })
        self.timerViewModel = timerViewModel

        sayThePomodoStarted()
        startFocus()

        output.write(string: "🍅 from \(dateFormatter.string(from: timerViewModel.outputs.startDate)) to \(dateFormatter.string(from: timerViewModel.outputs.endDate))\n")
        sleepTime = timeInterval / TimeInterval(outputLength)
        while !timerViewModel.outputs.progress.isFinished {
            outputLine(for: timerViewModel.outputs.progress.fractionCompleted)
            Thread.sleep(forTimeInterval: sleepTime)
        }
        outputLine(for: 1.0)
        output.write(string: "\nTimer ended\n")
        sayThePomodoEnded()
        stopFocus()
        Thread.sleep(forTimeInterval: intervalBeforePuttingDisplayToSleep)
        putDisplayToSleep()
        exit(EXIT_SUCCESS)
    }

    private func outputLine(for fractionCompleted: Double) {
        let completedChars = Int(fractionCompleted * Double(outputLength))
        let remainingChars = outputLength - completedChars
        let completedString = String(repeatElement("#", count: completedChars))
        let remainingString = String(repeatElement(".", count: remainingChars))
        output.write(string: "[\(completedString)\(remainingString)]\r")
    }

    private func startFocus() {
        let task = Process.launchedProcess(launchPath: "/usr/bin/open", arguments: ["focus://focus"])
        task.waitUntilExit()
    }

    private func stopFocus() {
        let task = Process.launchedProcess(launchPath: "/usr/bin/open", arguments: ["focus://unfocus"])
        task.waitUntilExit()
    }

    private func sayThePomodoStarted() {
        let task = Process.launchedProcess(launchPath: "/usr/bin/say", arguments: ["--voice=Alice", "Go ! Andiamo a lavorare."])
        task.waitUntilExit()
    }

    private func sayThePomodoEnded() {
        let task = Process.launchedProcess(launchPath: "/usr/bin/say", arguments: ["--voice=Alice", "Il pomodoro è finito."])
        task.waitUntilExit()
    }

    private func putDisplayToSleep() {
        let task = Process.launchedProcess(launchPath: "/usr/bin/pmset", arguments: ["displaysleepnow"])
        task.waitUntilExit()
    }
}
