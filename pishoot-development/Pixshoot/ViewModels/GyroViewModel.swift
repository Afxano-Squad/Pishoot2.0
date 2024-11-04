import CoreMotion
import SwiftUI
import UIKit

class GyroViewModel: ObservableObject {
    private let gyroManager: GyroMotionManager
    private var lockedYaw: Double?
    private var lockedPitch: Double?
    private var lockedRoll: Double?

    @Published var yaw: Double = 0.0
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var isSuccess = false
    @Published var isRollSuccess = false  // New state for roll success
    @Published var isPitchSuccess = false  // New state for pitch success
    @Published var guidanceText: String = ""

    private let tolerance = 0.1

    private var hapticGenerator: UIImpactFeedbackGenerator?  // Add haptic feedback generator
    
    // Observe device orientation
    var orientationManager = DeviceOrientationManager.shared

    init(gyroManager: GyroMotionManager = GyroMotionManager()) {
        self.gyroManager = gyroManager
        self.hapticGenerator = UIImpactFeedbackGenerator(style: .medium)  // Initialize with desired feedback style
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
        isRollSuccess = false  // Reset roll success state
        isPitchSuccess = false  // Reset pitch success state
        isSuccess = false  // Reset isSuccess to ensure haptic will trigger on next success
        objectWillChange.send()  // Notify subscribers
        print("Rest gyro")
    }

    private func checkSuccess() {
        let pitchDiff = abs(pitch)
        let rollDiff = abs(roll)

        // Check for pitch success
        isPitchSuccess = pitchDiff < tolerance
        if isPitchSuccess {
            guidanceText = "Pitch Success!"
        }

        // Check for roll success
        isRollSuccess = rollDiff < tolerance
        if isRollSuccess {
            guidanceText = "Roll Success!"
        }

        // Store previous isSuccess state
        let previousSuccess = isSuccess
        isSuccess = isPitchSuccess && isRollSuccess

        // Trigger haptic feedback only when transitioning from false to true
        if isSuccess && !previousSuccess {
            guidanceText = "Both Success!"
            hapticGenerator?.impactOccurred()  // Trigger haptic feedback when success is first achieved
        }
    }

    private func updateGuidance() {
        if pitch > tolerance {
            guidanceText = "Point Down"
        } else if pitch < -tolerance {
            guidanceText = "Point Up"
        } else if roll > tolerance {
            guidanceText = "Rotate Left"
        } else if roll < -tolerance {
            guidanceText = "Rotate Right"
        } else {
            guidanceText = "Hold Steady"
        }
    }
    
    
    // Computed property to determine rotation angle
    var rotationAngle: Angle {
        switch orientationManager.currentOrientation {
        case .portrait: return .degrees(0)
        case .landscapeLeft: return .degrees(90)
        case .landscapeRight: return .degrees(-90)
        case .portraitUpsideDown: return .degrees(180)
        default: return .degrees(0)
        }
    }
    
    
}
