import Foundation
import UIKit
import Combine

class AccelerometerViewModel: ObservableObject {
    private var accelerometerManager: AccelerometerManager
    private var cancellables = Set<AnyCancellable>()
    private var hapticGenerator: UIImpactFeedbackGenerator?
    @Published var accelerationZ: Double = 0.0
    @Published var accelerationX: Double = 0.0
    @Published var isAcclero: Bool = false
    @Published var lockedBaselineZ: Double? = nil
    @Published var lockedBaselineX: Double? = nil
    @Published var guidanceText: String = ""
    let numberOfBars = 15

    init(accelerometerManager: AccelerometerManager = AccelerometerManager()) {
        self.accelerometerManager = accelerometerManager
        self.hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
        

        accelerometerManager.$accelerationZ
            .sink { [weak self] newZ in
                self?.accelerationZ = newZ
                self?.checkAcceleration()
            }
            .store(in: &cancellables)

        accelerometerManager.$accelerationX
            .sink { [weak self] newX in
                self?.accelerationX = newX
                self?.checkAcceleration()
            }
            .store(in: &cancellables)
    }
    

    func start() {
        accelerometerManager.startUpdates()
        
    }

    func stop() {
        accelerometerManager.stopUpdates()
    }

    func lockAcceleration() {
        lockedBaselineZ = accelerationZ
        lockedBaselineX = accelerationX
    }

    func resetAcceleration() {
        lockedBaselineZ = nil
        lockedBaselineX = nil
    }
    
    func checkAcceleration() {
        let previousSuccess = isAcclero
        let midIndex = numberOfBars / 2
        let currentIndex = calculateDynamicIndexZ()
        if currentIndex < midIndex {
            isAcclero = false
            guidanceText = "Point up"
        } else if currentIndex > midIndex {
            isAcclero = false
            guidanceText = "Point down"
        } else {
            guidanceText = "You are centered!"
            isAcclero = true
        }
        
        if isAcclero && !previousSuccess{
            hapticGenerator?.impactOccurred()
        }
    }

    func calculateDynamicIndexZ() -> Int {
        let midIndex = numberOfBars / 2
        let offsetZ = lockedBaselineZ ?? 0.0
        let adjustedZ = accelerationZ - offsetZ
        let scaledZ = Int(adjustedZ * 6.5)
        let adjustedIndex = midIndex + scaledZ
        return max(0, min(numberOfBars - 1, adjustedIndex))
    }

    func calculateDynamicIndexX() -> Int {
        let midIndex = numberOfBars / 2
        let offsetX = lockedBaselineX ?? 0.0
        let adjustedX = accelerationX - offsetX
        let scaledX = Int(adjustedX * 6.5)
        let adjustedIndex = midIndex + scaledX
        return max(0, min(numberOfBars - 1, adjustedIndex))
    }
}
