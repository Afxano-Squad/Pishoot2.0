import Foundation
import AVFoundation
import RealityKit
import UIKit
import ARKit

class CameraController: NSObject, ObservableObject {

    @Published var CameraManager: CameraManager?
    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?

    var delegate: CameraDelegate?
    var arView: ARView

    init(arView: ARView) {
        self.arView = arView
        super.init()
    }

    private func setupCamera(lense: AVCaptureDevice.DeviceType) {
        captureSession = AVCaptureSession()
        photoOutput = AVCapturePhotoOutput()

        guard let captureSession = captureSession,
              let photoOutput = photoOutput else {
            print("Camera setup failed")
            return
        }

        guard let videoDevice = AVCaptureDevice.default(lense, for: .video, position: .back),
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

        photoOutput.isHighResolutionCaptureEnabled = true
    }

    func capturePhoto(completion: @escaping (UIImage?, UIImage?, UIImage?) -> Void) {
        pauseARSession() // Pause AR session sebelum memulai sesi capture
        
        setupCamera(lense: .builtInWideAngleCamera)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
            print("Camera session started")

            // Tambahkan jeda sebelum foto pertama
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Jeda 0.5 detik
                let settings = AVCapturePhotoSettings()
                settings.isHighResolutionPhotoEnabled = true

                // Capture foto pertama (Wide-angle)
                self.photoOutput?.capturePhoto(with: settings, delegate: self)
                print("First photo captured")

                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
                    // Capture foto kedua (Ultra-wide)
                    self.setupCamera(lense: .builtInUltraWideCamera)
                    self.captureSession?.startRunning()
                    print("Switched to ultra-wide camera")

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.photoOutput?.capturePhoto(with: settings, delegate: self)
                        print("Second photo captured")
                    }

                    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
                        // Foto ketiga (Wide-angle dengan zoom)
                        self.setupCamera(lense: .builtInWideAngleCamera)
                        self.captureSession?.startRunning()
                        print("Switched back to wide-angle camera")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.captureZoomedPhoto { zoomedPhoto in
                                self.stopCameraSession() // Hentikan sesi kamera
                                self.resumeARSession() // Aktifkan kembali AR session
                                completion(nil, nil, zoomedPhoto)
                                print("All photos captured and AR session resumed.")
                            }
                        }
                    }
                }
            }
        }
    }


    func cleanupAfterCapture() {
        stopCameraSession() // Stop camera session
        resumeARSession()   // Resume AR session
    }


    func captureZoomedPhoto(completion: @escaping (UIImage?) -> Void) {
        pauseARSession() // Pastikan AR session dihentikan

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to access wide-angle camera")
            completion(nil)
            return
        }

        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = 2.0
            device.unlockForConfiguration()

            let settings = AVCapturePhotoSettings()
            settings.isHighResolutionPhotoEnabled = true

            self.photoOutput?.capturePhoto(with: settings, delegate: self)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                do {
                    try device.lockForConfiguration()
                    device.videoZoomFactor = 1.0
                    device.unlockForConfiguration()
                    print("Camera zoom reset to normal (1.0)")
                } catch {
                    print("Failed to reset zoom: \(error.localizedDescription)")
                }
            }

            print("Zoomed photo captured")
        } catch {
            print("Failed to set zoom: \(error.localizedDescription)")
            completion(nil)
        }

        resumeARSession() // Kembali ke AR session setelah selesai
    }


    
    func pauseAndCapturePhoto() {
        pauseARSession()
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.1) {
            self.capturePhoto { _, _,_  in
                self.resumeARSession()
            }
        }
    }

    func pauseARSession() {
        arView.session.pause()
        
        
        print("AR session paused.")
    }

    func resumeARSession() {
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        print("AR session resumed.")
    }

    func stopCameraSession() {
        captureSession?.stopRunning()
        captureSession = nil
        photoOutput = nil
        print("Camera session stopped.")
    }
}


extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            cleanupAfterCapture()
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("Failed to process photo data")
            cleanupAfterCapture()
            return
        }

        DispatchQueue.main.async {
            print("Photo captured successfully")
            PhotoLibraryHelper.requestPhotoLibraryPermission { authorized in
                if authorized {
                    PhotoLibraryHelper.saveImagesToAlbum(images: [image])
                } else {
                    print("Photo library permission denied")
                }
            }
            self.delegate?.didCaptureComplete(image: image)
        }
    }
}

