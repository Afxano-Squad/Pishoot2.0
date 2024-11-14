//
//  ARViewContainer.swift
//  FinalChallengeDummy3
//
//  Created by Farid Andika on 22/10/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var arView: ARView

    func makeUIView(context: Context) -> ARView {
        // Memeriksa izin kamera saat memulai sesi
        checkCameraPermission()
        return arView
    }
    
    // Fungsi untuk memulai atau mereset sesi AR tanpa deteksi bidang
    func startARSession() {
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    // Fungsi untuk memeriksa izin kamera
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startARSession() // Langsung mulai sesi jika izin diberikan
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.startARSession()
                    }
                } else {
                    print("Camera access denied.")
                }
            }
        default:
            print("Camera access restricted or denied.")
        }
    }

    // Fungsi untuk menempatkan objek mengambang di udara
    func addFloatingObject(at distance: Float = -2.0, height: Float = 1.5) {
        guard let cameraTransform = arView.session.currentFrame?.camera.transform else {
            print("Camera transform not found")
            return
        }
        
        // Memuat model dari file .usdz
        guard let modelEntity = try? Entity.load(named: "squarebilly.usdz") else {
            print("Failed to load squarebilly.usdz")
            return
        }
        
        // Buat anchor entity untuk menampung modelEntity
        let anchorEntity = AnchorEntity()
        anchorEntity.addChild(modelEntity)
        
        // Tempatkan objek di depan kamera pada ketinggian tertentu
        var translation = matrix_identity_float4x4
        translation.columns.3.z = distance  // 2 meter di depan
        translation.columns.3.y = height    // 1.5 meter di atas ground
        let finalTransform = simd_mul(cameraTransform, translation)
        anchorEntity.transform.matrix = finalTransform
        
        // Tambahkan anchor ke ARView
        arView.scene.addAnchor(anchorEntity)
    }
}

