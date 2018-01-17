import Foundation
import Commander

let main = command { (durationInMinutes:Int) in
    let timerViewCLI = TimerViewCLI(output: FileHandle.standardOutput)
    timerViewCLI.start(timeInterval: TimeInterval(10))
}

main.run()
