//
//  DeviceOrientationManager.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 13/07/24.
//

import CoreMotion
import UIKit

class DeviceOrientationManager {
    static let shared = DeviceOrientationManager()
    
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    
    var currentOrientation: UIDeviceOrientation = .portrait
    
    private init() {
        startAccelerometerUpdates()
    }
    
    private func startAccelerometerUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
                if let accelerometerData = self?.motionManager.accelerometerData {
                    self?.determineOrientation(from: accelerometerData)
                }
            }
        }
    }
    
    private func determineOrientation(from accelerometerData: CMAccelerometerData) {
        let x = accelerometerData.acceleration.x
        let y = accelerometerData.acceleration.y
        
        if y < -0.75 {
            currentOrientation = .portrait
        } else if y > 0.75 {
            currentOrientation = .portraitUpsideDown
        } else if x < -0.75 {
            currentOrientation = .landscapeLeft
        } else if x > 0.75 {
            currentOrientation = .landscapeRight
        }
    }
    
    func stopAccelerometerUpdates() {
        motionManager.stopAccelerometerUpdates()
        timer?.invalidate()
    }
}
