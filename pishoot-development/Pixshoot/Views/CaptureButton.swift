//
//  CaptureButton.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import SwiftUI

struct CaptureButton: View {
    var action: () -> Void  // This action can be the function to capture the picture
    @Binding var isCapturing: Bool
    @Binding var animationProgress: CGFloat
    @ObservedObject var gyroViewModel: GyroViewModel
    @Binding var isLocked: Bool

    var body: some View {
        Button(action: {
            self.action()
            withAnimation(.linear(duration: 0.5)) {
                self.animationProgress = 1
            }
        }) {
            ZStack {
                if !isCapturing {
                    // Outer Circle
                    Circle()
                        .stroke(
                            gyroViewModel.isPitchSuccess ? .green : .red,
                            lineWidth: 4
                        )
                        .frame(width: 60, height: 60)

                    //                    // Inner Circle based on pitch success
                    Circle()
                        .fill(gyroViewModel.isPitchSuccess ? .green : .red)
                        .frame(width: 40, height: 40)
                        .rotation3DEffect(
                            Angle(degrees: gyroViewModel.pitch * 180 / .pi),
                            axis: (x: 1, y: 0, z: 0)
                        )
                    //
                    //                    // Small Circle for Lock Indicator
                    Circle()
                        .stroke(
                            gyroViewModel.isRollSuccess ? .green : .red,
                            lineWidth: 3
                        )
                        .frame(width: 20, height: 20)
                        .offset(y: -50)

                    //                    // Roll circle based on roll success
                    Circle()
                        .fill(gyroViewModel.isRollSuccess ? .green : .red)
                        .frame(width: 15, height: 15)
                        .offset(y: -50)
                        .rotationEffect(
                            Angle(degrees: gyroViewModel.roll * 0.2 * 360 / .pi)
                        )
                }

                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 75, height: 75)

                Circle()
                    .trim(from: 0, to: animationProgress)
                    .stroke(Color("pishootYellow"), lineWidth: 10)
                    .frame(width: 65, height: 65)
                    .rotationEffect(Angle(degrees: -90))
            }
            .onChange(of: isLocked) { locked in
                            if !locked {
                                gyroViewModel.resetGyroValues()  // Ensure gyro reset when unlocked
                            }
                        }
            .onAppear {
                gyroViewModel.startGyros()
            }
            .onDisappear {
                gyroViewModel.stopGyros()
            }
        }
        .onChange(of: isCapturing) { oldValue, newValue in
            if !newValue {
                withAnimation(.linear(duration: 0.3)) {
                    self.animationProgress = 0
                }
            }
        }
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
