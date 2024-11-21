//
//  sample.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 03/11/24.
//

import AVKit
import SDWebImageSwiftUI
import SwiftUI

struct BlackOverlayWithHole: View {
    @Binding var currentStepIndex: Int
    let tutorialSteps: [TutorialStep]
    var onTutorialComplete: () -> Void  // Completion handler
    @Binding var isLocked: Bool

    var body: some View {
        ZStack {
            if currentStepIndex < tutorialSteps.count {
                let step = tutorialSteps[currentStepIndex]

                GeometryReader { geometry in
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                }

                VStack(spacing: 16) {
                    VStack {
                        // Judul langkah tutorial
                        Text(step.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        // Deskripsi langkah tutorial
                        Text(step.text)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)

                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)  // Tambahkan bentuk background
                            .fill(Color.blue)  // Ganti dengan warna yang kamu inginkan
                    )
                    .padding(.bottom, 30)
                    .padding(.horizontal)

                    AnimatedImage(name: step.gifName)
                        .resizable()
                        .frame(width: 325, height: 400)
                        .cornerRadius(10)

                    // Progress Indicator
                    HStack(spacing: 10) {
                        Spacer()
                        ForEach(0..<tutorialSteps.count, id: \.self) { index in
                            ZStack {
                                Circle()
                                    .fill(Color("BackgroundProgress"))
                                    .frame(
                                        width: index == currentStepIndex
                                            ? 14 : 10,
                                        height: index == currentStepIndex
                                            ? 14 : 10
                                    )
                                    .shadow(
                                        color: index == currentStepIndex
                                            ? Color.blue.opacity(0.4)
                                            : Color.clear, radius: 5)

                                Circle()
                                    .fill(
                                        index < currentStepIndex + 1
                                            ? Color("Button") : Color.clear
                                    )
                                    .frame(
                                        width: index == currentStepIndex
                                            ? 8.4 : 6,
                                        height: index == currentStepIndex
                                            ? 8.4 : 6
                                    )
                                    .animation(
                                        .easeInOut, value: currentStepIndex)
                            }
                        }
                        Spacer()
                    }

                    // Tempatkan tombol di sini dengan spacer
                    ZStack {
                        // Ruang tetap untuk tombol agar tidak mengubah tata letak
                        Color.clear
                            .frame(height: 50) // Atur tinggi sesuai kebutuhan
                        if currentStepIndex == tutorialSteps.count - 1 {
                            Button(action: {
                                onTutorialComplete()  // Call completion handler
                            }) {
                                Text("Got it!")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Secondary"))
                                    .padding()
                                    .background(Color("Primary"))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }

                
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            // Geser ke kiri
                            if value.translation.width < -50
                                && currentStepIndex < tutorialSteps.count - 1
                            {
                                currentStepIndex += 1
                            }
                            // Geser ke kanan
                            if value.translation.width > 50
                                && currentStepIndex > 0
                            {
                                currentStepIndex -= 1
                            }
                        }
                )
                // Observe changes in `isLocked` to increment `currentStepIndex` when locked
                .onChange(of: isLocked) { _, newValue in
                    if currentStepIndex == 2 && newValue {
                        currentStepIndex += 1
                    }
                }
            }
        }
        .background(.red)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {

    BlackOverlayWithHole(
        currentStepIndex: .constant(2), tutorialSteps: tutorialSteps,
        onTutorialComplete: {},
        isLocked: .constant(false))
}
