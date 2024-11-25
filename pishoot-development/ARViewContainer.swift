//
//  ARViewContainer.swift
//  FinalChallengeDummy3
//
//  Created by Farid Andika on 22/10/24.
//


import SwiftUI
import RealityKit
import ARKit
import AVFoundation

struct ARViewContainer: UIViewRepresentable {
    @Binding var arView: ARView
    private static var isSessionStarted = false
    
    func makeCoordinator() -> ARViewCoordinator {
        return ARViewCoordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        arView.session.delegate = context.coordinator
        checkCameraPermission()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            if !ARViewContainer.isSessionStarted {
                startARSession()
                ARViewContainer.isSessionStarted = true
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        if !ARViewContainer.isSessionStarted {
                            startARSession()
                            ARViewContainer.isSessionStarted = true
                        }
                    }
                } else {
                    print("Camera access denied.")
                }
            }
        default:
            print("Camera access restricted or denied.")
        }
    }
    
    private func startARSession() {
        guard ARViewContainer.isSessionStarted == false else {
            print("AR session is already running, skipping start")
            return
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = []
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        ARViewContainer.isSessionStarted = true
        print("AR session started")
    }
}

class ARViewCoordinator: NSObject, ARSessionDelegate {
    var onFrameCaptured: ((UIImage) -> Void)?
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let pixelBuffer = frame.capturedImage
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        
        // Notify WatchConnectivityManager to send the image to the watch
        WatchConnectivityManager.shared.sendPreviewToWatch(uiImage)
        
        // Optional: Callback for additional processing if needed
        onFrameCaptured?(uiImage)
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("ARSession failed with error: \(error.localizedDescription)")
        restartARSession(session)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("ARSession was interrupted")
    }
    
    private func restartARSession(_ session: ARSession) {
        DispatchQueue.main.async {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = []
            session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            print("ARSession restarted after failure")
        }
    }
    
}
