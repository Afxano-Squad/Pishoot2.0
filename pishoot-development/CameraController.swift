//
//  CameraController.swift
//  FinalChallengeDummy3
//
//  Created by Farid Andika on 14/11/24.
//

import Foundation
import AVFoundation
import RealityKit
import UIKit
import ARKit

class CameraController: NSObject, ObservableObject {
    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var arView: ARView?

    init(arView: ARView) {
        self.arView = arView
        super.init()
        setupCamera()
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        photoOutput = AVCapturePhotoOutput()

        guard let captureSession = captureSession,
              let photoOutput = photoOutput else {
            print("Camera setup failed")
            return
        }

        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoInput) else {
            print("Failed to add video input")
            return
        }
        captureSession.addInput(videoInput)
        print("Video input added to session")

        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
            print("Photo output added to session")
        }

        // Enable high-resolution capture
        photoOutput.isHighResolutionCaptureEnabled = true
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        guard let arView = arView else { return }
        arView.session.pause()
        print("AR session paused")

        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            guard let session = self.captureSession else { return }
            session.startRunning()
            print("Camera session started")

            DispatchQueue.main.async {
                guard let photoOutput = self.photoOutput else {
                    print("Photo output is nil")
                    completion(nil)
                    return
                }

                // Ensure high-resolution settings are valid
                guard photoOutput.isHighResolutionCaptureEnabled else {
                    print("High resolution capture not enabled")
                    completion(nil)
                    return
                }

                let settings = AVCapturePhotoSettings()
                settings.isHighResolutionPhotoEnabled = true
                photoOutput.capturePhoto(with: settings, delegate: self)
            }
        }
    }

    func returnToARSession() {
        guard let arView = self.arView else { return }
        
        captureSession?.stopRunning()
        captureSession = nil // Pastikan AVCaptureSession dihentikan
        print("Camera session stopped")
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            let configuration = ARWorldTrackingConfiguration()
            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            print("AR session resumed")
        }
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("Failed to process photo data")
            return
        }

        DispatchQueue.main.async {
            print("Photo captured successfully")
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) // Save the photo to the photo library
            self.returnToARSession()
        }
    }
}
