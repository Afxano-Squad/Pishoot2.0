import Foundation
import WatchKit
import WatchConnectivity

class WatchViewModel: ObservableObject {
    private let session = WKExtendedRuntimeSession()
    
    @Published var isActive = true
    
    init() {
        setupExtendedRuntime()
    }
    
    private func setupExtendedRuntime() {
        session.start()
    }
    
    func keepDisplayActive() {
        guard session.state != .running else { return }
        session.start()
    }
    
    func stopKeepingDisplayActive() {
        session.invalidate()
    }
    
    
    func playHapticFeedback() {
        WKInterfaceDevice.current().play(.success)
    }
}
