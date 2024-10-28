//
//  GyroManager.swift
//  FinalChallengeDummy3
//
//  Created by Yuriko AIshinselo on 26/10/24.
//

import CoreMotion

class GyroMotionManager {
    private let motion = CMMotionManager()

    func startGyros(updateInterval: TimeInterval, onUpdate: @escaping (CMDeviceMotion) -> Void) {
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = updateInterval
            motion.startDeviceMotionUpdates(using: .xArbitraryZVertical)
            
            Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
                if let data = self.motion.deviceMotion {
                    onUpdate(data)
                }
            }
        }
    }

    func stopGyros() {
        motion.stopDeviceMotionUpdates()
    }
    
    func lockGyroCoordinates() -> CMAttitude? {
        return motion.deviceMotion?.attitude
    }
}
