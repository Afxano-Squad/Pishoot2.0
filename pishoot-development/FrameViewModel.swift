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

protocol CameraDelegate {
    func didCaptureComplete(image: UIImage?) -> Void
}

class FrameViewModel: ObservableObject {
    @Published var model = FrameModel()
    @Published var isCapturingPhoto: Bool = false
    
    private var timer: Timer?
    var arView: ARView
    lazy var cameraController = CameraController(arView: arView)

    init(arView: ARView) {
        self.arView = arView
        self.cameraController.delegate = self
    }

    func toggleFrame(at arView: ARView) {
        if model.anchor != nil {
            removeFrame(from: arView)
        } else {
            addFrame(to: arView)
        }
    }

    func capturePhoto() {
        
        
        cameraController.capturePhoto { [weak self] (image: UIImage?) in

        }
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
        let frameThickness: Float = 0.005
        let outerSize: Float = 0.2
        let material = SimpleMaterial(color: .black, isMetallic: true)

        let top = ModelEntity(mesh: MeshResource.generateBox(size: [outerSize, frameThickness, frameThickness]), materials: [material])
        let bottom = ModelEntity(mesh: MeshResource.generateBox(size: [outerSize, frameThickness, frameThickness]), materials: [material])
        let left = ModelEntity(mesh: MeshResource.generateBox(size: [frameThickness, outerSize, frameThickness]), materials: [material])
        let right = ModelEntity(mesh: MeshResource.generateBox(size: [frameThickness, outerSize, frameThickness]), materials: [material])

        top.position = [0, (outerSize - frameThickness) / 2, 0]
        bottom.position = [0, -(outerSize - frameThickness) / 2, 0]
        left.position = [-(outerSize - frameThickness) / 2, 0, 0]
        right.position = [(outerSize - frameThickness) / 2, 0, 0]

        let anchor = AnchorEntity(world: [0, 0, 0])
        anchor.addChild(top)
        anchor.addChild(bottom)
        anchor.addChild(left)
        anchor.addChild(right)

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
                model.overlayColor = .green
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
        cameraController.captureSession = nil // **Perubahan: Set `captureSession` menjadi `nil` untuk memastikan direset**
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

