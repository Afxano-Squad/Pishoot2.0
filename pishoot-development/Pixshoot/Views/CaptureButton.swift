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
                        .stroke(
                            gyroViewModel.isPitchSuccess ? Color("Primary") : .white,
                            lineWidth: 4
                        )
                        .frame(width: 70, height: 70)

                    Circle()
                        .fill(gyroViewModel.isPitchSuccess ? Color("Primary") : .white)
                        .frame(width: 57, height: 57)
                        .rotation3DEffect(
                            Angle(degrees: gyroViewModel.pitch * 180 / .pi),
                            axis: (x: 1, y: 0, z: 0),
                            anchor: .center,
                            perspective: 0
                        )

                    Circle()
                        .stroke(
                            gyroViewModel.isRollSuccess ? Color("Primary") : .white,
                            lineWidth: 2
                        )
                        .frame(width: 17, height: 17)
                        .offset(y: -53)

                    Circle()
                        .fill(gyroViewModel.isRollSuccess ? Color("Primary") : .white)
                        .frame(width: 10, height: 10)
                        .offset(y: -53)
                        .rotationEffect(
                            Angle(degrees: gyroViewModel.roll * 0.2 * 360 / .pi)
                        )
                }



                Circle()
                    .trim(from: 0, to: animationProgress)
                    .stroke(Color("pishootYellow"), lineWidth: 10)
                    .frame(width: 65, height: 65)
                    .rotationEffect(Angle(degrees: -90))
            }
            .accessibilityLabel("Capture")
            .accessibilityHint(isCapturing ? "Capturing in progress" : "Tap to capture a picture")
        }
        .accessibilityElement(children: .combine) // Menggabungkan semua elemen dalam Button
        .onAppear {
            prepareAudioPlayer() // Siapkan audio player untuk suara sukses
        }
        .onChange(of: isCapturing) { _, newValue in
            if !newValue {
                withAnimation(.linear(duration: 0.3)) {
                    self.animationProgress = 0
                }
            }
        }
        .onChange(of: gyroViewModel.isPitchSuccess) { _, newValue in
            checkSuccessConditions() // Cek kondisi ketika pitch berubah
            UIAccessibility.post(notification: .announcement, argument: newValue ? "Pitch level is correct" : "Adjust the pitch level")
        }
        .onChange(of: gyroViewModel.isRollSuccess) { _, newValue in
            checkSuccessConditions() // Cek kondisi ketika roll berubah
            UIAccessibility.post(notification: .announcement, argument: newValue ? "Roll level is correct" : "Adjust the roll level")
        }
        .onChange(of: isLocked) { locked in
            if !locked {
                gyroViewModel.resetGyroValues()
            }
        }
    }

    // Fungsi untuk menyiapkan audio player
    func prepareAudioPlayer() {
        if let soundURL = Bundle.main.url(forResource: "benar", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Failed to load sound: \(error)")
            }
        } else {
            print("Audio file not found.")
        }
    }

    func playSuccessSound() {
        audioPlayer?.play()
    }

    // Fungsi untuk memeriksa apakah pitch dan roll keduanya sukses
    func checkSuccessConditions() {
        // Hanya mainkan suara jika pitch dan roll sukses, dan kondisinya baru berubah
        if gyroViewModel.isPitchSuccess && gyroViewModel.isRollSuccess {
            if !previousPitchSuccess || !previousRollSuccess {
                playSuccessSound()
            }
        }

        // Simpan kondisi saat ini sebagai kondisi sebelumnya
        previousPitchSuccess = gyroViewModel.isPitchSuccess
        previousRollSuccess = gyroViewModel.isRollSuccess
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
