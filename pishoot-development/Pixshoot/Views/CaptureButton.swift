//
//  CaptureButton.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import SwiftUI
import AVFoundation

struct CaptureButton: View {
    var action: () -> Void
    @Binding var isCapturing: Bool
    @Binding var animationProgress: CGFloat
    @ObservedObject var gyroViewModel: GyroViewModel
    @ObservedObject var frameViewModel: FrameViewModel
    @Binding var isLocked: Bool
    

    var body: some View {
        Button(action: {
//            frameViewModel.capturePhoto() // Memanggil fungsi dengan pause-resume AR
            action()
        }) {
            Circle()
                .fill(Color.white)
                .frame(width: 80, height: 80)
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 4)
                        .frame(width: 70, height: 70)
                )
        }
        .accessibilityElement(children: .combine) // Menggabungkan semua elemen dalam Button
        .onChange(of: isCapturing) { _, newValue in
            if !newValue {
                withAnimation(.linear(duration: 0.3)) {
                    self.animationProgress = 0
                }
            }
        }
    }
}
