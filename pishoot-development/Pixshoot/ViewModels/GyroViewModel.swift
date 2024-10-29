import CoreMotion
import SwiftUI

class GyroViewModel: ObservableObject {
    private let gyroManager: GyroMotionManager
    private var lockedYaw: Double?
    private var lockedPitch: Double?
    private var lockedRoll: Double?
    
    @Published var yaw: Double = 0.0
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var isSuccess = false
    @Published var isRollSuccess = false // New state for roll success
    @Published var isPitchSuccess = false // New state for pitch success
    @Published var guidanceText: String = ""
    
    private let tolerance = 0.1
    
    init(gyroManager: GyroMotionManager = GyroMotionManager()) {
        self.gyroManager = gyroManager
    }
    
    func startGyros() {
        gyroManager.startGyros(updateInterval: 1.0 / 60.0) { [weak self] data in
            DispatchQueue.main.async {
                self?.yaw = (data.attitude.yaw - (self?.lockedYaw ?? 0.0))
                self?.pitch = (data.attitude.pitch - (self?.lockedPitch ?? 0.0))
                self?.roll = (data.attitude.roll - (self?.lockedRoll ?? 0.0))
                self?.checkSuccess()
                self?.updateGuidance()
            }
        }
    }

    func stopGyros() {
        gyroManager.stopGyros()
    }
    
    func lockGyroCoordinates() {
        if let attitude = gyroManager.lockGyroCoordinates() {
            lockedYaw = attitude.yaw
            lockedPitch = attitude.pitch
            lockedRoll = attitude.roll
        }
    }
    
    func resetGyroValues() {
        yaw = 0.0
        pitch = 0.0
        roll = 0.0
        isRollSuccess = false // Reset roll success state
        isPitchSuccess = false // Reset pitch success state
    }
    
    private func checkSuccess() {
        let pitchDiff = abs(pitch)
        let rollDiff = abs(roll)
        
        // Check for pitch success
        if pitchDiff < tolerance {
            isPitchSuccess = true
            guidanceText = "Pitch Success!"
        } else {
            isPitchSuccess = false
        }

        // Check for roll success
        if rollDiff < tolerance {
            isRollSuccess = true
            guidanceText = "Roll Success!"
        } else {
            isRollSuccess = false
        }

        // Overall success condition
        isSuccess = isPitchSuccess && isRollSuccess;

        if isSuccess {
            guidanceText = "Both Success!";
        }
    }

    private func updateGuidance() {
        if pitch > tolerance {
            guidanceText = "Tilt Up"
        } else if pitch < -tolerance {
            guidanceText = "Tilt Down"
        } else if roll > tolerance {
            guidanceText = "Rotate Left"
        } else if roll < -tolerance {
            guidanceText = "Rotate Right"
        } else {
            guidanceText = "Hold Steady"
        }
    }
}
