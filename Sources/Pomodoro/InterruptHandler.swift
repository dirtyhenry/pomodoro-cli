import Foundation

/// Manages SIGINT (Ctrl+C) signal handling for graceful interruption
class InterruptHandler {
    enum State {
        case none
        case firstInterrupt
        case secondInterrupt
    }

    private var state: State = .none
    private let stateLock = NSLock()
    private var semaphore: DispatchSemaphore?
    private var signalSource: DispatchSourceSignal?

    /// Configures the handler to listen for SIGINT signals
    /// - Parameter semaphore: The semaphore to signal when interrupted
    func setup(semaphore: DispatchSemaphore) {
        self.semaphore = semaphore

        // Ignore default SIGINT handling so we can handle it ourselves
        signal(SIGINT, SIG_IGN)

        // Create dispatch source for SIGINT on global queue (CLI apps don't run main RunLoop)
        signalSource = DispatchSource.makeSignalSource(signal: SIGINT, queue: .global())

        signalSource?.setEventHandler { [weak self] in
            self?.handleInterrupt()
        }

        signalSource?.resume()
    }

    /// Handles an interrupt signal
    private func handleInterrupt() {
        stateLock.lock()
        defer { stateLock.unlock() }

        switch state {
        case .none:
            // First interrupt - signal the semaphore to wake the timer
            state = .firstInterrupt
            semaphore?.signal()

        case .firstInterrupt:
            // Second interrupt - force exit immediately
            state = .secondInterrupt
            exit(0)

        case .secondInterrupt:
            // Should never reach here, but just in case
            exit(0)
        }
    }

    /// Checks if an interrupt has occurred
    var isInterrupted: Bool {
        stateLock.lock()
        defer { stateLock.unlock() }
        return state == .firstInterrupt
    }

    /// Cancels the signal handler
    func cancel() {
        signalSource?.cancel()
        signalSource = nil
        signal(SIGINT, SIG_DFL) // Restore default signal handling
    }
}
