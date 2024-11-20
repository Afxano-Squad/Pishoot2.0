//
//  AccelerometerManager.swift
//  Pixshoot
//
//  Created by Yuriko AIshinselo on 19/11/24.
//

import CoreMotion
import Combine

class AccelerometerManager: ObservableObject {
    private var motionManager: CMMotionManager
    private var cancellables = Set<AnyCancellable>()
    
    @Published var accelerationZ: Double = 0.0
    
    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 0.09
    }
    
    func startUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
                guard let self = self, let validData = data else { return }
                self.accelerationZ = validData.acceleration.z
            }
        }
    }
    
    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
    

}
