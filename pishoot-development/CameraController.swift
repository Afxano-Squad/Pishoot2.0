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
    var arView: ARView // Referensi ARView untuk pause dan resume

    init(arView: ARView) {
        self.arView = arView
        super.init()
    }

    // Fungsi untuk mengatur sesi kamera saat diperlukan
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
        setupCamera(lense: .builtInWideAngleCamera)
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            self.captureSession?.startRunning()
            print("Camera session started")

            DispatchQueue.main.async {
                let settings = AVCapturePhotoSettings()
                settings.isHighResolutionPhotoEnabled = true

                // Foto pertama (Wide-angle)
                self.photoOutput?.capturePhoto(with: settings, delegate: self)
                print("First photo captured")

                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
                    self.stopCameraSession()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        // Foto kedua (Ultra-wide)
                        self.setupCamera(lense: .builtInUltraWideCamera)
                        // Should be run on background thread!
                        
                        self.captureSession?.startRunning()
                        print("Switched to ultra-wide camera")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.photoOutput?.capturePhoto(with: settings, delegate: self)
                            print("Second photo captured")

                            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
                                //
                                self.stopCameraSession()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    // Foto ketiga (Wide-angle dengan zoom)
                                    self.setupCamera(lense: .builtInWideAngleCamera)
                                    
                                    // Should run on backgorund thread!
                                    self.captureSession?.startRunning()
                                    print("Switched back to wide-angle camera")

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.captureZoomedPhoto { image in
                                            completion(nil, nil, image)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func captureZoomedPhoto(completion: @escaping (UIImage?) -> Void) {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to access wide-angle camera")
            completion(nil)
            return
        }

        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = 2.0 // Set zoom level to 2.0
            device.unlockForConfiguration()

            let settings = AVCapturePhotoSettings()
            settings.isHighResolutionPhotoEnabled = true
            self.photoOutput?.capturePhoto(with: settings, delegate: self)
            print("Zoomed photo captured")
        } catch {
            print("Failed to set zoom: \(error.localizedDescription)")
            completion(nil)
        }
    }



    func pauseAndCapturePhoto() {
        pauseARSession()
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.2) {
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
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("Failed to process photo data")
            return
        }

        DispatchQueue.main.async {
            print("Photo captured successfully")
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.delegate?.didCaptureComplete(image: image)

            // Resume AR session setelah foto diambil
//            self.resumeARSession()

            // Hentikan sesi kamera setelah selesai
            self.stopCameraSession()
        }
    }
}

