//
//  CameraViewModel.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.

import SwiftUI
import AVFoundation
import Combine

class CameraViewModel: ObservableObject {
    private var cameraManager: CameraManager
    private var cancellables = Set<AnyCancellable>()

    @Published var isFlashOn = false {
        didSet {
            cameraManager.isFlashOn = isFlashOn
        }
    }
    @Published var isCapturingPhoto = false
    @Published var isBlackScreenVisible = false
    @Published var captureProgress: CGFloat = 0
    @Published var selectedZoomLevel: CGFloat = 1.0 {
        didSet {
            cameraManager.setZoomLevel(zoomLevel: selectedZoomLevel)
        }
    }
    @Published var timerDuration: Int = 0
    @Published var countdown: Int = -1
    @Published var position: CGPoint = CGPoint(x: 393.0 / 2, y: 852.0 / 2)
    @Published var lastPhotos: [UIImage] = []
    @Published var isMultiRatio: Bool = false {
        didSet {
            cameraManager.isMultiRatio = isMultiRatio
        }
    }
    

    private var countdownTimer: Timer?

    var session: AVCaptureMultiCamSession? {
        cameraManager.session
    }

    init(cameraManager: CameraManager = CameraManager.shared) {
        self.cameraManager = cameraManager
        bindCameraManager()

        WatchConnectivityManager.shared.takePictureOnWatch = { [weak self] in
            self?.capturePhotos { images in
            }
        }
    }

    private func bindCameraManager() {
        cameraManager.$isFlashOn
            .receive(on: DispatchQueue.main)
            .assign(to: &$isFlashOn)

        cameraManager.$isCapturingPhoto
            .receive(on: DispatchQueue.main)
            .assign(to: &$isCapturingPhoto)

        cameraManager.$selectedZoomLevel
            .receive(on: DispatchQueue.main)
            .assign(to: &$selectedZoomLevel)

        cameraManager.$isBlackScreenVisible
            .receive(on: DispatchQueue.main)
            .assign(to: &$isBlackScreenVisible)
        cameraManager.$isMultiRatio
            .receive(on: DispatchQueue.main)
            .assign(to: &$isMultiRatio)
    }

    func startSession() {
        cameraManager.startSession()
    }

    func stopSession() {
        cameraManager.stopSession()
    }

    func toggleFlash() {
        isFlashOn.toggle()
    }

    func capturePhotos(completion: @escaping ([UIImage]) -> Void) {
        if timerDuration > 0 {
            startCountdownTimer {
                self.takePictures(completion: completion)
            }
        } else {
            takePictures(completion: completion)
        }
    }

    private func takePictures(completion: @escaping ([UIImage]) -> Void) {
        captureProgress = 0
        withAnimation(.linear(duration: 1)) {
            self.captureProgress = 1
        }
        cameraManager.capturePhotos { [weak self] images in
            self?.lastPhotos = images
            completion(images)
        }
    }

    private func startCountdownTimer(completion: @escaping () -> Void) {
        countdown = timerDuration
        flashCountdown()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.countdown > 1 {
                self.flashCountdown()
                self.countdown -= 1
            } else {
                self.countdown -= 1
                timer.invalidate()
                completion()
            }
        }
    }

    private func flashCountdown() {
        turnTorch(on: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.turnTorch(on: false)
        }
    }

    func turnTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            if on {
                try device.setTorchModeOn(level: 1.0)
            }
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used: \(error)")
        }
    }

    func setZoomLevel(zoomLevel: CGFloat) {
        cameraManager.setZoomLevel(zoomLevel: zoomLevel)
    }
}
