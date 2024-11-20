//
//  AccelerometerManager.swift
//  Pixshoot
//
//  Created by Yuriko AIshinselo on 21/11/24.
//

import CoreMotion
import Combine

class AccelerometerManager: ObservableObject {
    private var motionManager: CMMotionManager
    private var cancellables = Set<AnyCancellable>()
    
    @Published var accelerationZ: Double = 0.0 // Z-axis
    @Published var accelerationX: Double = 0.0 // X-axis
    
    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 0.09
    }
    
    func startUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
                guard let self = self, let validData = data else { return }
                self.accelerationZ = validData.acceleration.z // Z-axis value
                self.accelerationX = validData.acceleration.x // X-axis value
            }
        }
    }
    
    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
}
