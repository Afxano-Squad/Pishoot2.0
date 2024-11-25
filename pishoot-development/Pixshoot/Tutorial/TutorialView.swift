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
    var onTutorialComplete: () -> Void
    @Binding var isLocked: Bool

    var body: some View {
        ZStack {
            // Langkah-langkah tutorial hanya ditampilkan jika currentStepIndex < 4
            if currentStepIndex <= 2 {
                if currentStepIndex < tutorialSteps.count {
                    let step = tutorialSteps[currentStepIndex]

                    GeometryReader { geometry in
                        Color.black.opacity(0.8)
                            .ignoresSafeArea()
                    }

                    VStack(spacing: 16) {
                        // Judul dan teks tutorial
                        VStack {
                            Text(step.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("Secondary"))

                            Text(step.text)
                                .font(.body)
                                .foregroundColor(Color("Secondary"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 10)
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Primary"))
                        )
                        .padding(.bottom, 30)

                        // Animasi GIF
                        AnimatedImage(name: step.gifName)
                            .resizable()
                            .frame(width: 325, height: 400)
                            .cornerRadius(10)

                        // Progress Indicator
                        HStack(spacing: 10) {
                            Spacer()
                            ForEach(0 ..< 3, id: \.self) {
                                index in
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
                        ZStack {
                            // Ruang tetap untuk tombol agar tidak mengubah tata letak
                            Color.clear
                                .frame(height: 50)  // Atur tinggi sesuai kebutuhan
                            if currentStepIndex == 2 {
                                Button(action: {
                                    currentStepIndex += 1
                                }) {
                                    Text("Got it!")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("Secondary"))
                                        .padding()
                                        .background(Color("Button"))
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < -50,
                                    currentStepIndex < tutorialSteps.count - 1
                                {
                                    currentStepIndex += 1
                                } else if value.translation.width > 50,
                                    currentStepIndex > 0
                                {
                                    currentStepIndex -= 1
                                }
                            }
                    )
                }
            } else {
                // Tampilan kosong di langkah ke-4
                Color.clear
                    .ignoresSafeArea()
            }
        }

        .onChange(of: isLocked) { _, newValue in
            if currentStepIndex == 3 && newValue {
                currentStepIndex += 1
            }
        }
    }
}

#Preview {

    BlackOverlayWithHole(
        currentStepIndex: .constant(2), tutorialSteps: tutorialSteps,
        onTutorialComplete: {},
        isLocked: .constant(false))
}
