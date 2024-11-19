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
    @Published var isRollSuccess = false
    @Published var isPitchSuccess = false
    @Published var guidanceText: String = ""

    private let tolerance = 0.1

    private var hapticGenerator: UIImpactFeedbackGenerator?
    
    // Observe device orientation
    var orientationManager = DeviceOrientationManager.shared

    init(gyroManager: GyroMotionManager = GyroMotionManager()) {
        self.gyroManager = gyroManager
        self.hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
    }

    func startGyros() {
        gyroManager.startGyros(updateInterval: 1.0 / 60.0) { [weak self] data in
            DispatchQueue.main.async {
                // Use the raw pitch value (no subtraction) for display
                self?.pitch = data.attitude.pitch
                self?.yaw = data.attitude.yaw
                self?.roll = data.attitude.roll
                
                self?.checkSuccess()
                self?.updateGuidance()
            }
        }
    }

    func stopGyros() {
        gyroManager.stopGyros()
    }

    func lockGyroCoordinates() {
        // Store the current pitch value without modifying the actual pitch
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
        isRollSuccess = false
        isPitchSuccess = false
        isSuccess = false
        objectWillChange.send()
        print("Reset gyro")
    }

    private func checkSuccess() {
        let pitchDiff = abs(pitch)
        let rollDiff = abs(roll)

        isPitchSuccess = pitchDiff < tolerance
        if isPitchSuccess {
            guidanceText = "Pitch Success!"
        }

        isRollSuccess = rollDiff < tolerance
        if isRollSuccess {
            guidanceText = "Roll Success!"
        }

        let previousSuccess = isSuccess
        isSuccess = isPitchSuccess && isRollSuccess

        if isSuccess && !previousSuccess {
            guidanceText = "Both Success!"
            hapticGenerator?.impactOccurred()
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
