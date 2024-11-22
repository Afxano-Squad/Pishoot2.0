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
    var arView: ARView // MENYIMPAN REFERENSI ARVIEW UNTUK PAUSE DAN RESUME AR SESSION

    init(arView: ARView) {
        self.arView = arView // MENYIMPAN ARVIEW SEBAGAI PROPERTY
        super.init()
        setupCamera() // INISIALISASI SESI KAMERA SAAT CONTROLLER DIBUAT
    }

    /// Mengatur ulang sesi kamera untuk memastikan dimulai dari awal setiap kali digunakan
    private func setupCamera() {
        captureSession = AVCaptureSession() // MEMBUAT ULANG `AVCaptureSession`
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
        print("Video input added to session") // LOG MENANDAKAN INPUT KAMERA BERHASIL DITAMBAHKAN

        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
            print("Photo output added to session") // LOG MENANDAKAN OUTPUT KAMERA BERHASIL DITAMBAHKAN
        }

        // MENGAKTIFKAN PENGAMBILAN FOTO RESOLUSI TINGGI
        photoOutput.isHighResolutionCaptureEnabled = true
    }
    
    /// Memulai proses pengambilan foto
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        pauseARSession() // PAUSE AR SESSION SEBELUM MENGAMBIL FOTO
        setupCamera()
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
                photoOutput.capturePhoto(with: settings, delegate: self) // MENGAMBIL FOTO
            }
        }
    }

    // FUNGSI UNTUK MEM-PAUSE AR SESSION
    private func pauseARSession() {
        arView.session.pause() // MENGHENTIKAN SEMENTARA AR SESSION
        print("AR session paused.")
    }

    // FUNGSI UNTUK MELANJUTKAN AR SESSION
    private func resumeARSession() {
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        print("AR session resumed.")
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
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) // MENYIMPAN FOTO KE GALERI
            self.delegate?.didCaptureComplete(image: image)
            self.resumeARSession() // RESUME AR SESSION SETELAH FOTO DIAMBIL
        }
    }
}
