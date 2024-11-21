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
    
    @Published var CameraManager: CameraManager?
    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?

    var delegate: CameraDelegate?
    
    init(arView: ARView) {
        super.init()
        setupCamera() // Inisialisasi sesi kamera saat controller dibuat
    }

    /// Mengatur ulang sesi kamera untuk memastikan dimulai dari awal setiap kali digunakan
    private func setupCamera() {
        captureSession = AVCaptureSession() // Membuat ulang `AVCaptureSession`
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
        print("Video input added to session") // Log menandakan input kamera berhasil ditambahkan

        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
            print("Photo output added to session") // Log menandakan output kamera berhasil ditambahkan
        }

        // Mengaktifkan pengambilan foto resolusi tinggi
        photoOutput.isHighResolutionCaptureEnabled = true
    }

    
    /// Memulai proses pengambilan foto
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        setupCamera()
        CameraManager?.isCapturingPhoto = true
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            self.captureSession?.startRunning()
            print("Camera session started")

            DispatchQueue.main.async {
                guard let photoOutput = self.photoOutput else {
                    print("Photo output is nil")
                    completion(nil)
                    return
                }

                let settings = AVCapturePhotoSettings()
                settings.isHighResolutionPhotoEnabled = true
                photoOutput.capturePhoto(with: settings, delegate: self) // Mengambil foto
            }
        }
    }

}

extension CameraController: AVCapturePhotoCaptureDelegate {
    /// Delegate untuk memproses foto yang telah diambil
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
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) // Menyimpan foto ke galeri
            self.delegate?.didCaptureComplete(image: image)
            
            
// Kembali ke AR session setelah foto selesai diproses
//            self.returnToARSession()
        }
    }
}
