//
//  GyroViewModel.swift
//  FinalChallengeDummy3
//
//  Created by Yuriko AIshinselo on 26/10/24.
//


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
    }
    
    private func checkSuccess() {
        let yawDiff = abs(yaw)
        let pitchDiff = abs(pitch)
        let rollDiff = abs(roll)
        
        if yawDiff < tolerance && pitchDiff < tolerance && rollDiff < tolerance {
            isSuccess = true
            guidanceText = "Success!"
        } else {
            isSuccess = false
        }
    }
    
    private func updateGuidance() {
        if yaw > tolerance {
            guidanceText = "Turn Left"
        } else if yaw < -tolerance {
            guidanceText = "Turn Right"
        } else if pitch > tolerance {
            guidanceText = "Tilt Up"
        } else if pitch < -tolerance {
            guidanceText = "Tilt Down"
        } else {
            guidanceText = "Hold Steady"
        }
    }
}
