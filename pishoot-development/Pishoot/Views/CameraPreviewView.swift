//
//  CameraPreviewView.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    class CameraPreview: UIView {
        var previewLayer: AVCaptureVideoPreviewLayer
        var countdownLabel: UILabel
        var session: AVCaptureSession
        var focusBox: UIView

        override init(frame: CGRect) {
            previewLayer = AVCaptureVideoPreviewLayer()
            countdownLabel = UILabel()
            countdownLabel.textAlignment = .center
            countdownLabel.textColor = .white
            countdownLabel.font = UIFont.systemFont(ofSize: 100, weight: .bold)
            countdownLabel.alpha = 0
            session = AVCaptureSession()
            focusBox = UIView()

            super.init(frame: frame)
            layer.addSublayer(previewLayer)
            addSubview(countdownLabel)

            focusBox.layer.borderColor = UIColor.yellow.cgColor
            focusBox.layer.borderWidth = 2
            focusBox.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            focusBox.isHidden = true
            addSubview(focusBox)

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(focusAndExposeTap(_:)))
            self.addGestureRecognizer(tapGestureRecognizer)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer.frame = bounds
            countdownLabel.frame = bounds
        }

        @objc func focusAndExposeTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let layerPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            let devicePoint = previewLayer.captureDevicePointConverted(fromLayerPoint: layerPoint)
            showFocusBox(at: layerPoint)
            focus(with: .autoFocus, exposureMode: .autoExpose, at: devicePoint)
        }

        private func showFocusBox(at point: CGPoint) {
            focusBox.center = point
            focusBox.isHidden = false
            focusBox.alpha = 1.0

            UIView.animate(withDuration: 1, animations: {
                self.focusBox.alpha = 0.0
            }) { _ in
                self.focusBox.isHidden = true
            }
        }

        private func focus(with focusMode: AVCaptureDevice.FocusMode, exposureMode: AVCaptureDevice.ExposureMode, at devicePoint: CGPoint) {
            guard let device = previewLayer.session?.inputs.first(where: { ($0 as? AVCaptureDeviceInput)?.device.deviceType == .builtInWideAngleCamera }) as? AVCaptureDeviceInput else { return }

            do {
                try device.device.lockForConfiguration()

                if device.device.isFocusPointOfInterestSupported && device.device.isFocusModeSupported(focusMode) {
                    device.device.focusPointOfInterest = devicePoint
                    device.device.focusMode = focusMode
                }

                if device.device.isExposurePointOfInterestSupported && device.device.isExposureModeSupported(exposureMode) {
                    device.device.exposurePointOfInterest = devicePoint
                    device.device.exposureMode = exposureMode
                }

                device.device.isSubjectAreaChangeMonitoringEnabled = true
                device.device.unlockForConfiguration()
            } catch {
                print("Error focusing on point: \(error)")
            }
        }
    }

    var session: AVCaptureSession
    @Binding var countdown: Int

    func makeUIView(context: Context) -> CameraPreview {
        let view = CameraPreview()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill

        if let wideAngleInput = session.inputs.first(where: { ($0 as? AVCaptureDeviceInput)?.device.deviceType == .builtInWideAngleCamera }) as? AVCaptureDeviceInput,
           let port = wideAngleInput.ports.first(where: { $0.mediaType == .video }) {
            let connection = AVCaptureConnection(inputPort: port, videoPreviewLayer: view.previewLayer)
            if session.canAddConnection(connection) {
                session.addConnection(connection)
            }

            do {
                try wideAngleInput.device.lockForConfiguration()
                wideAngleInput.device.videoZoomFactor = 1.0
                wideAngleInput.device.unlockForConfiguration()
            } catch {
                print("Error setting initial zoom factor: \(error)")
            }
        }

        return view
    }

    func updateUIView(_ uiView: CameraPreview, context: Context) {
        uiView.countdownLabel.text = "\(countdown)"
        uiView.countdownLabel.alpha = countdown > 0 ? 1 : 0
    }
}


#Preview {
    ContentView()
}
