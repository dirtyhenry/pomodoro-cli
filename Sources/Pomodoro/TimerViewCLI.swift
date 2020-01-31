//
//  TimerViewCLI.swift
//  pomodoro-cli
//
//  Created by Mickaël Floc'hlay on 06/11/2017.
//

import Foundation

extension FileHandle {
    func write(string: String) {
        write(string.data(using: .utf8)!)
    }
}

public class TimerViewCLI {
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

    public init(output: FileHandle) {
        self.output = output
    }

    public func start(timeIntervalString: String) {
        do {
            let timeInterval = try TimeInterval.fromHumanReadableString(timeIntervalString)
            start(timeInterval: timeInterval)
        } catch {
            output.write(string: "Could not start the timer with interval \(timeIntervalString)")
        }
    }
    
    public func start(timeInterval: TimeInterval) {
        let timerViewModel = TimerViewModel(timeInterval: timeInterval)
        self.timerViewModel = timerViewModel

        didStart()

        let beginning = dateFormatter.string(from: timerViewModel.outputs.startDate)
        let end = dateFormatter.string(from: timerViewModel.outputs.endDate)
        output.write(string: "🍅 from \(beginning) to \(end)\n")
        sleepTime = timeInterval / TimeInterval(outputLength)
        while !timerViewModel.outputs.progress.isFinished {
            outputLine(for: timerViewModel.outputs.progress.fractionCompleted)
            Thread.sleep(forTimeInterval: sleepTime)
        }
        outputLine(for: 1.0)
        output.write(string: "\nTimer ended\n")

        didEnd()

        exit(EXIT_SUCCESS)
    }

    private func outputLine(for fractionCompleted: Double) {
        let completedChars = Int(fractionCompleted * Double(outputLength))
        let remainingChars = outputLength - completedChars
        let completedString = String(repeatElement("#", count: completedChars))
        let remainingString = String(repeatElement(".", count: remainingChars))
        output.write(string: "[\(completedString)\(remainingString)]\r")
    }

    private func didStart() {
        // TODO: make sure the file exists
        let task = Process.launchedProcess(launchPath: "~/.pomodoro-cli/didStart.sh", arguments: [])
        task.waitUntilExit()
    }

    private func didEnd() {
        // TODO: make sure the file exists
        let task = Process.launchedProcess(launchPath: "~/.pomodoro-cli/didEnd.sh", arguments: [])
        task.waitUntilExit()
    }
}
