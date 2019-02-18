import Commander
import Foundation

let durationOption = Option("duration",
                            default: Double(1500),
                            description: "The duration of the pomodoro in seconds.")

let main = command(durationOption) { (durationInSeconds: TimeInterval) in
    let timerViewCLI = TimerViewCLI(output: FileHandle.standardOutput)
    timerViewCLI.start(timeInterval: durationInSeconds)
}

main.run()
