//
//  Untitled.swift
//  Pixshoot
//
//  Created by Yuriko AIshinselo on 21/11/24.
//

import Foundation
import Combine

class AcclerometerViewModel: ObservableObject {
    private var accelerometerManager = AccelerometerManager()
    private var cancellables = Set<AnyCancellable>()

    @Published var accelerationZ: Double = 0.0
    @Published var lockedBaselineZ: Double? = nil // Change this to clarify the purpose

    init() {
        // Subscribe to accelerometer updates
        accelerometerManager.$accelerationZ
            .sink { [weak self] newAcceleration in
                self?.accelerationZ = newAcceleration
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
        // Set the current acceleration as the baseline and reset the rectangle
        lockedBaselineZ = accelerationZ
    }

    func resetAcceleration() {
        // Clear the baseline to unlock
        lockedBaselineZ = nil
    }
}
