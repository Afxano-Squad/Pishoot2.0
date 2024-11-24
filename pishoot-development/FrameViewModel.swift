//
//  FrameViewMOdel.swift
//  FinalChallengeDummy3
//
//  Created by Farid Andika on 22/10/24.
//

import Foundation
import RealityKit
import SwiftUI
import ARKit


class FrameViewModel: ObservableObject {
    
    @Published var model = FrameModel()
    @Published var isCapturingPhoto: Bool = false
    
    private var timer: Timer?
    var arView: ARView
    lazy var cameraController = CameraController(arView: arView)
    private var cameraManager: CameraManager
    
    init(arView: ARView) {
        self.arView = arView
//        self.cameraController.delegate = self
        
        cameraManager = CameraManager.shared
        self.cameraManager.delegate = self
    }
    
    func toggleFrame(at arView: ARView) {
        if model.anchor != nil {
            removeFrame(from: arView)
        } else {
            addFrame(to: arView)
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
    
    func addFrame(to arView: ARView) {
        if let cameraTransform = arView.session.currentFrame?.camera.transform {
            let modelEntity = createPhotoFrame()
            let distance: Float = -0.5
            var translation = matrix_identity_float4x4
            translation.columns.3.z = distance
            let finalTransform = simd_mul(cameraTransform, translation)
            modelEntity.transform.matrix = finalTransform
            arView.scene.addAnchor(modelEntity)
            model.anchor = modelEntity
            startLiveAlignmentCheck(arView: arView)
        }
    }
    
    func removeFrame(from arView: ARView) {
        if let anchor = model.anchor {
            arView.scene.removeAnchor(anchor)
            model.anchor = nil
        }
        stopLiveAlignmentCheck()
    }
    
    private func createPhotoFrame() -> AnchorEntity {
        let frameThickness: Float = 0.004
        let outerWidth: Float = 0.06
        let outerHeight: Float = 0.12
        let dashLength: Float = 0.02
        let dashSpacing: Float = 0.01
        let material = UnlitMaterial(color: .yellow)  // Gantilah ke UnlitMaterial

        let anchor = AnchorEntity(world: [0, 0, 0])

        func createDashedLine(length: Float, axis: SIMD3<Float>, positionOffset: SIMD3<Float>) {
            var currentLength: Float = 0
            while currentLength < length {
                let dash = ModelEntity(mesh: MeshResource.generateBox(size: [axis.x != 0 ? dashLength : frameThickness,
                                                                                 axis.y != 0 ? dashLength : frameThickness,
                                                                                 frameThickness]),
                                           materials: [material])
                dash.position = positionOffset + (axis * (currentLength + dashLength / 2))
                anchor.addChild(dash)
                currentLength += dashLength + dashSpacing
            }
        }

        createDashedLine(length: outerWidth - dashLength, axis: SIMD3<Float>(1, 0, 0), positionOffset: SIMD3<Float>(-outerWidth / 2 + dashLength / 2, outerHeight / 2, 0))
        createDashedLine(length: outerWidth - dashLength, axis: SIMD3<Float>(1, 0, 0), positionOffset: SIMD3<Float>(-outerWidth / 2 + dashLength / 2, -outerHeight / 2, 0))
        createDashedLine(length: outerHeight - dashLength, axis: SIMD3<Float>(0, 1, 0), positionOffset: SIMD3<Float>(-outerWidth / 2, -outerHeight / 2 + dashLength / 2, 0))
        createDashedLine(length: outerHeight - dashLength, axis: SIMD3<Float>(0, 1, 0), positionOffset: SIMD3<Float>(outerWidth / 2, -outerHeight / 2 + dashLength / 2, 0))

        let plusHorizontal = ModelEntity(mesh: MeshResource.generateBox(size: [dashLength, frameThickness, frameThickness]), materials: [material])
        let plusVertical = ModelEntity(mesh: MeshResource.generateBox(size: [frameThickness, dashLength, frameThickness]), materials: [material])
        plusHorizontal.position = SIMD3<Float>(0, 0, 0)
        plusVertical.position = SIMD3<Float>(0, 0, 0)
        anchor.addChild(plusHorizontal)
        anchor.addChild(plusVertical)

        return anchor
    }

    private func startLiveAlignmentCheck(arView: ARView) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            self.checkOverlayColor(arView: arView)
        }
    }
    
    private func stopLiveAlignmentCheck() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkOverlayColor(arView: ARView) {
        guard let anchor = model.anchor else { return }
        guard let cameraTransform = arView.session.currentFrame?.camera.transform else { return }
        
        let anchorPosition = anchor.transform.translation
        let cameraPosition = cameraTransform.translation
        
        let distance = simd_distance(anchorPosition, cameraPosition)
        let acceptableDistance: Float = 0.5
        let acceptableAngle: Float = 15.0
        
        if distance <= acceptableDistance {
            let cameraForward = cameraTransform.columns.2
            let anchorForward = anchor.transform.matrix.columns.2
            
            let angle = acos(dot(cameraForward, anchorForward) / (length(cameraForward) * length(anchorForward))) * (180.0 / .pi)
            
            if angle <= acceptableAngle {
                model.overlayColor = .yellow
                model.alignmentStatus = "Pas, sudah dalam kotak!"
            } else {
                model.overlayColor = .red
                model.alignmentStatus = "Belum pas bang, masukin kotak"
            }
        } else {
            model.overlayColor = .red
            model.alignmentStatus = "Belum pas bang, masukin kotak"
        }
    }
    
    // Menghentikan sesi kamera dan melanjutkan kembali ke AR session
    func returnToARSession() {
        
        // Hentikan sesi kamera
        cameraController.captureSession?.stopRunning()
        cameraManager.stopSession()
        cameraController.captureSession = nil // **Perubahan: Set `captureSession` menjadi `nil` untuk memastikan direset**
        cameraManager.session = nil
        print("Camera session stopped")
        
        // Lanjutkan AR session
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            let configuration = ARWorldTrackingConfiguration()
            self.arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            print("AR session resumed") // Log menandakan AR session dilanjutkan
            
        }
    }
}

extension FrameViewModel: CameraDelegate{
    func didCaptureComplete(image: UIImage?) {
        print("Capture Complete and photo saved!")
        isCapturingPhoto = false
        self.returnToARSession()
    }
    
}

extension simd_float4x4 {
    var translation: SIMD3<Float> {
        return [columns.3.x, columns.3.y, columns.3.z]
    }
}

