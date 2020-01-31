import Commander
import Foundation
import Pomodoro

let timeInterval = Option("duration",
                          default: "1500",
                          description: "The duration of the pomodoro in seconds (100) or in minutes (10m).")

let main = command(timeInterval) { (timeInterval: String) in
    let timerViewCLI = TimerViewCLI(output: FileHandle.standardOutput)
    timerViewCLI.start(timeIntervalString: timeInterval)
}

main.run()
