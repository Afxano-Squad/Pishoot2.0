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
    @Binding var isLocked: Bool

    // Tambahkan AVAudioPlayer untuk memutar suara
    @State private var audioPlayer: AVAudioPlayer?

    // Variabel untuk menyimpan kondisi sebelumnya dari pitch dan roll
    @State private var previousPitchSuccess = false
    @State private var previousRollSuccess = false

    var body: some View {
        Button(action: {
            self.action()
            withAnimation(.linear(duration: 0.5)) {
                self.animationProgress = 1
            }
        }) {
            ZStack {
                if !isCapturing {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 70, height: 70)
                        .rotationEffect(Angle(degrees: -90))
                    Circle()
                        .fill(Color.white)
                        .frame(width: 60, height: 60)
                }

                Circle()
                    .trim(from: 0, to: animationProgress)
                    .stroke(Color("Primary"), lineWidth: 10)
                    .frame(width: 65, height: 65)
                    .rotationEffect(Angle(degrees: -90))
            }
            .accessibilityLabel("Capture")
            .accessibilityHint(isCapturing ? "Capturing in progress" : "Tap to capture a picture")
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


    func playSuccessSound() {
        audioPlayer?.play()
    }


}

#Preview {
    // Provide a sample GyroViewModel if necessary for previewing
    CaptureButton(
        action: {
            print("Capture picture action triggered")  // Replace with your capture logic
        }, isCapturing: .constant(false), animationProgress: .constant(0.5),
        gyroViewModel: GyroViewModel(), isLocked: .constant(false))
}
