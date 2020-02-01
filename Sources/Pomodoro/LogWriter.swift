import Foundation

struct LogWriter {
    static let journalFile = "journal.yml"

    func writeLog(pomodoroDescription: PomodoroDescription) {
        do {
            let journalFileHandle = try FileHandle(forWritingTo: Environment.dotDirectory.appendingPathComponent(LogWriter.journalFile))

            journalFileHandle.seekToEndOfFile()
            journalFileHandle.write(string: pomodoroDescription.description)
            journalFileHandle.closeFile()
        } catch {
            print("An error happened: \(error)")
        }
    }
}
