import Commander
import Foundation
import Pomodoro

let timeInterval = Option("duration",
                          default: "1500",
                          description: "The duration of the pomodoro in seconds.")

let main = command(timeInterval) { (timeInterval: String) in
    let timerViewCLI = TimerViewCLI(output: FileHandle.standardOutput)
    timerViewCLI.start(timeIntervalString: timeInterval)
}

main.run()
