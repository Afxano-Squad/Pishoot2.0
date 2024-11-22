import Foundation
import UIKit
import Combine

class AccelerometerViewModel: ObservableObject {
    private var accelerometerManager: AccelerometerManager
    private var cancellables = Set<AnyCancellable>()
    private var hapticGenerator: UIImpactFeedbackGenerator?
    @Published var accelerationZ: Double = 0.0
    @Published var accelerationX: Double = 0.0
    @Published var isAccleroX: Bool = false
    @Published var isAccleroZ: Bool = false
    @Published var lockedBaselineZ: Double? = nil
    @Published var lockedBaselineX: Double? = nil
    @Published var guidanceTextX: String = ""
    @Published var guidanceTextZ: String = ""
    let numberOfBars = 15

    init(accelerometerManager: AccelerometerManager = AccelerometerManager()) {
        self.accelerometerManager = accelerometerManager
        self.hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
        

        accelerometerManager.$accelerationZ
            .sink { [weak self] newZ in
                self?.accelerationZ = newZ
                self?.checkAccelerationZ()
            }
            .store(in: &cancellables)

        accelerometerManager.$accelerationX
            .sink { [weak self] newX in
                self?.accelerationX = newX
                self?.checkAccelerationX()
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
    
    func checkAccelerationZ() {
        let previousSuccess = isAccleroZ
        let midIndex = numberOfBars / 2
        let currentIndex = calculateDynamicIndexZ()
        print("IsaccleroZ : \(isAccleroZ)")
        print("IsaccleroX : \(isAccleroX)")
        if currentIndex < midIndex {
            isAccleroZ = false
            guidanceTextZ = "Point up"
        } else if currentIndex > midIndex {
            isAccleroZ = false
            guidanceTextZ = "Point down"
        } else {
            guidanceTextZ = "You are centered!"
            isAccleroZ = true
        }
        
        if isAccleroZ && !previousSuccess{
            hapticGenerator?.impactOccurred()
        }
    }
    
    func checkAccelerationX() {
        let previousSuccess = isAccleroX
        let midIndex = numberOfBars / 2
        let currentIndex = calculateDynamicIndexX()
        if currentIndex < midIndex {
            isAccleroX = false
            guidanceTextX = "Point up"
        } else if currentIndex > midIndex {
            isAccleroX = false
            guidanceTextX = "Point down"
        } else {
            guidanceTextX = "You are centered!"
            isAccleroX = true
        }
        
        if isAccleroX && !previousSuccess{
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
