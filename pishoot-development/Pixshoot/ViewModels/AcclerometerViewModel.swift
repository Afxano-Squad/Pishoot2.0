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
        print("Locked baseline X: \(lockedBaselineX), Acceleration X: \(accelerationX)")
    }
    
    func resetAcceleration() {
        lockedBaselineZ = nil
        lockedBaselineX = nil
    }
    
    func checkAccelerationZ() {
        let previousSuccess = isAccleroZ
        let midIndex = numberOfBars / 2
        let currentIndex = calculateDynamicIndexZ()
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
        
        //        let index = calculateDynamicIndexX()
        //        print("Roll view index updated to: \(index)")
        //        updateRollView(index: index)
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
            
            // Hitung delta
            let delta = accelerationX - offsetX
            
            // Normalisasi dan skalakan delta
            let maxDelta = 0.5 // Nilai maksimum delta yang diharapkan
            let normalizedDelta = delta / maxDelta // Normalisasi ke range -1 sampai 1
            let scaledX = Int(normalizedDelta * Double(midIndex))
            
            // Hitung index final
            let adjustedIndex = midIndex - scaledX // Kurangi dari midIndex untuk membalik arah
            
            // Debug log
            print("""
                X-axis Debug:
                Current Acceleration: \(accelerationX)
                Baseline: \(offsetX)
                Raw Delta: \(delta)
                Normalized Delta: \(normalizedDelta)
                Scaled Value: \(scaledX)
                Final Index: \(max(0, min(numberOfBars - 1, adjustedIndex)))
                """)
            
            return max(0, min(numberOfBars - 1, adjustedIndex))
        }
        
    
    
    //    func updateRollView(index: Int) {
    //        DispatchQueue.main.async {
    //            // Perbarui UI di sini
    //            print("Updating roll view to index: \(index)")
    //        }
    //    }
    
    
}
