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
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("ARSession failed with error: \(error.localizedDescription)")
    }

    func sessionWasInterrupted(_ session: ARSession) {
        print("ARSession was interrupted")
    }

//    func sessionInterruptionEnded(_ session: ARSession) {
//        print("ARSession interruption ended")
//        restartARSession(for: session)
//    }

//    private func restartARSession(for session: ARSession) {
//        guard ARViewContainer.isSessionStarted else {
//            print("AR session not active, skipping restart")
//            return
//        }
//        let configuration = ARWorldTrackingConfiguration()
//        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//        print("AR session restarted")
//    }
}
