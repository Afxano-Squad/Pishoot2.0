//
//  AcclerometerViewModel.swift
//  Pixshoot
//
//  Created by Yuriko AIshinselo on 19/11/24.
//

import Foundation
import Combine

class AcclerometerViewModel: ObservableObject {
    private var accelerometerManager = AccelerometerManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var accelerationZ: Double = 0.0
    
    init() {
        // Subscribe to the accelerometer updates
        accelerometerManager.$accelerationZ
                    .assign(to: \.accelerationZ, on: self)
                    .store(in: &cancellables)
    }
    
    func start() {
        accelerometerManager.startUpdates()
    }
    
    func stop() {
        accelerometerManager.stopUpdates()
    }
}
