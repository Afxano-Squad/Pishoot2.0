import Foundation
import Combine

class AcclerometerViewModel: ObservableObject {
    private var accelerometerManager = AccelerometerManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var accelerationZ: Double = 0.0
    @Published var lockedAccelerationZ: Double? = nil // Stores the locked value of accelerationZ
    
    private var originalAccelerationZ: Double = 0.0 // Keeps track of the original value before locking
    
    init() {
        // Subscribe to the accelerometer updates
        accelerometerManager.$accelerationZ
            .sink { [weak self] newAcceleration in
                if self?.lockedAccelerationZ == nil {  // Only update if not locked
                    self?.accelerationZ = newAcceleration
                }
            }
            .store(in: &cancellables)
    }
    
    func start() {
        accelerometerManager.startUpdates()
    }
    
    func stop() {
        accelerometerManager.stopUpdates()
    }
    
    // Lock the current accelerationZ value
    func lockAcceleration() {
        lockedAccelerationZ = accelerationZ
    }
    
    // Reset the accelerationZ value to the original or locked value
    func resetAcceleration() {
        if let lockedValue = lockedAccelerationZ {
            accelerationZ = lockedValue
        } else {
            accelerationZ = originalAccelerationZ
        }
    }
    
    // Optionally, store the original value of accelerationZ before locking
    func storeOriginalAcceleration() {
        originalAccelerationZ = accelerationZ
    }
}
