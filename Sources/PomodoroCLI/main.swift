import Commander
import Foundation
import Pomodoro

let durationAsString = Option("duration",
                              default: "25m",
                              description: "The duration of the pomodoro in seconds (100) or in minutes (10m).")

let main = command(durationAsString) { (durationAsString: String) in
    let timerViewCLI = TimerViewCLI(output: FileHandle.standardOutput)
    timerViewCLI.start(durationAsString: durationAsString)
}

main.run()
