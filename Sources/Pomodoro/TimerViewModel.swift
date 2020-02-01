import Foundation

protocol TimerViewModelInputs {}

protocol TimerViewModelOutputs {
    var startDate: Date { get }
    var endDate: Date { get }
    var progress: Progress { get }
}

protocol TimerViewModelType {
    var inputs: TimerViewModelInputs { get }
    var outputs: TimerViewModelOutputs { get }
}

class TimerViewModel: TimerViewModelType, TimerViewModelInputs, TimerViewModelOutputs {
    let startDate: Date
    let timerDuration: TimeInterval

    var endDate: Date {
        return startDate.addingTimeInterval(timerDuration)
    }

    var progress: Progress {
        let progress = Progress(totalUnitCount: Int64(timerDuration * 1000))
        let elapsedTime = Date().timeIntervalSince(startDate)
        progress.completedUnitCount = Int64(elapsedTime * 1000)
        return progress
    }

    init(timeInterval: TimeInterval) {
        startDate = Date()
        timerDuration = timeInterval
    }

    // MARK: - Define inputs & outputs

    var inputs: TimerViewModelInputs { return self }
    var outputs: TimerViewModelOutputs { return self }
}
