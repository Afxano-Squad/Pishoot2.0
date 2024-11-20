import Combine

class AccelerometerViewModel: ObservableObject {
    private var accelerometerManager = AccelerometerManager()
    private var cancellables = Set<AnyCancellable>()

    @Published var accelerationZ: Double = 0.0
    @Published var accelerationX: Double = 0.0
    @Published var lockedBaselineZ: Double? = nil
    @Published var lockedBaselineX: Double? = nil

    init() {
        accelerometerManager.$accelerationZ
            .sink { [weak self] newZ in
                self?.accelerationZ = newZ
            }
            .store(in: &cancellables)

        accelerometerManager.$accelerationX
            .sink { [weak self] newX in
                self?.accelerationX = newX
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
        lockedBaselineZ = accelerationZ
        lockedBaselineX = accelerationX
    }

    func resetAcceleration() {
        lockedBaselineZ = nil
        lockedBaselineX = nil
    }
}
