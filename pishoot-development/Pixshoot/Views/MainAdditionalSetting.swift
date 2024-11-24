//
//  MainAdditionalSetting.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 26/06/24.
//

import SwiftUI

struct MainAdditionalSetting: View {
    @State private var isTimerOptionsVisible: Bool = false
    @Binding var isGridOn: Bool
    var toggleFlash: () -> Void
    var isFlashOn: Bool
    @State private var isFlashPopup = false
    var cameraViewModel: CameraViewModel
    @ObservedObject var gyroViewModel: GyroViewModel

    var body: some View {
        VStack {
            if !isTimerOptionsVisible {
                ZStack {
                    // Flash popup
                    if isFlashPopup {
                        VStack {
                            Text(isFlashOn ? "Flash On" : "Flash Off")
                                .font(.callout)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Capsule())
                                .transition(.scale)
                        }
                        .offset(y: -50) // Position above the button
                    }

                    HStack(spacing: 25) {
                        // Flash button
                        Button(action: handleFlashToggle) {
                            buttonImage(systemName: isFlashOn ? "bolt.fill" : "bolt.slash.fill", isActive: isFlashOn)
                        }

                        // Grid button
                        Button(action: { isGridOn.toggle() }) {
                            buttonImage(systemName: "grid", isActive: isGridOn)
                        }

                        // Timer button
                        Button(action: { withAnimation { isTimerOptionsVisible.toggle() } }) {
                            buttonImage(systemName: "timer", isActive: cameraViewModel.timerDuration != 0)
                        }
                    }
                }
            }

            // Timer options
            if isTimerOptionsVisible {
                timerOptions
            }
        }
    }

    private func handleFlashToggle() {
        withAnimation {
            toggleFlash()
        }
        isFlashPopup = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isFlashPopup = false
            }
        }
    }

    private func buttonImage(systemName: String, isActive: Bool) -> some View {
        Image(systemName: systemName)
            .frame(width: 40, height: 40)
            .foregroundColor(isActive ? Color("Primary") : .white)
            .background(Color.black.opacity(0.5))
            .clipShape(Circle())
            .rotationEffect(gyroViewModel.rotationAngle)
            .animation(.easeInOut(duration: 0.3), value: gyroViewModel.rotationAngle)
    }

    private var timerOptions: some View {
        HStack(spacing: 20) {
            Button(action: { withAnimation(.spring()) { isTimerOptionsVisible.toggle() } }) {
                buttonImage(systemName: "timer", isActive: cameraViewModel.timerDuration != 0)
            }
            timerButton(duration: 3)
            timerButton(duration: 5)
            timerButton(duration: 10)
            timerButton(duration: 0, label: "Off")
        }
        .padding(.trailing, 20)
        .background(Color.black.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func timerButton(duration: Int, label: String? = nil) -> some View {
        Button(action: { cameraViewModel.timerDuration = duration }) {
            Text(label ?? "\(duration)s")
                .foregroundColor(cameraViewModel.timerDuration == duration ? Color("Primary") : .white)
                .padding(10)
                .rotationEffect(gyroViewModel.rotationAngle)
                .animation(.easeInOut(duration: 0.3), value: gyroViewModel.rotationAngle)
        }
    }
}
#Preview {
    MainAdditionalSetting(isGridOn: .constant(false), toggleFlash: {}, isFlashOn: true, cameraViewModel: CameraViewModel(), gyroViewModel: GyroViewModel())
}
