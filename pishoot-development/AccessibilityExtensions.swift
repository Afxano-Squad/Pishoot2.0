//
//  AccessibilityExtensions.swift
//  Pixshoot
//
//  Created by Farid Andika on 02/11/24.
//

import UIKit
import SwiftUI

// Extension untuk semua UIView
extension UIView {
    func setAccessibility(label: String, hint: String? = nil, value: String? = nil) {
        self.isAccessibilityElement = true
        self.accessibilityLabel = label
        self.accessibilityHint = hint
        if let value = value {
            self.accessibilityValue = value
        }
    }
}

// Extension for  CameraPreviewView
extension CameraPreviewView.CameraPreview {
    func configureAccessibility() {
        self.setAccessibility(label: "Camera preview", hint: "Pixshoot is ready to take picture")

        countdownLabel.setAccessibility(label: "Countdown timer", hint: "Shows a countdown before taking a photo", value: countdownLabel.text)

        focusBox.setAccessibility(label: "Focus box", hint: "Pixshoot is focusing on this tapped area")
    }
}

