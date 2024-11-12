//
//  sample.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 03/11/24.
//

import SwiftUI

struct BlackOverlayWithHole: View {
    @Binding var currentStepIndex: Int
    @State private var hasStartedDelay = false  // Track if delay has started
    let tutorialSteps: [TutorialStep]
    var onTutorialComplete: () -> Void  // Completion handler
    @Binding var isLocked: Bool

    var body: some View {
        ZStack {
            if currentStepIndex < tutorialSteps.count {
                let step = tutorialSteps[currentStepIndex]

                GeometryReader { geometry in
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .mask(
                            ZStack {
                                Rectangle()
                                    .frame(
                                        width: geometry.size.width,
                                        height: geometry.size.height)

                                RoundedRectangle(cornerRadius: 25)
                                    .frame(
                                        width: step.overlayWidth,
                                        height: step.overlayHeight
                                    )
                                    .position(
                                        x: UIScreen.main.bounds.width / 2
                                            + step.overlayPositionX,
                                        y: UIScreen.main.bounds.height / 2
                                            + step.overlayPositionY
                                    )
                                    .blendMode(.destinationOut)

                                // Transparent area for step 2 to pass interactions
                                if currentStepIndex == 2
                                    || currentStepIndex == 4
                                {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: 0, height: 0)
                                        .position(x: 0, y: 0)
                                        .allowsHitTesting(false)
                                }

                                // Add two holes for the first tutorial step
                                if currentStepIndex == 3 {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: 150, height: 70)
                                        .position(
                                            x: UIScreen.main.bounds.width / 2,
                                            y: 120
                                        )
                                        .blendMode(.destinationOut)
                                }
                            }
                            .compositingGroup()

                        )
                }
                .allowsHitTesting(
                    currentStepIndex != 2 && currentStepIndex != 4)

                VStack(spacing: 16) {
                    Image(systemName: step.image)
                        .resizable()
                        .frame(width: step.imageWidth, height: step.imageHeight)
                    if currentStepIndex != 2 && currentStepIndex != 4 {
                        Text(step.text)
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                            .frame(width: 320)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if currentStepIndex != 0 && currentStepIndex != 2
                        && currentStepIndex != 4
                    {
                        Button(action: {
                            if currentStepIndex < tutorialSteps.count - 1 {
                                currentStepIndex += 1
                            } else {
                                onTutorialComplete()  // Call completion handler
                            }
                        }) {
                            Text(
                                currentStepIndex < tutorialSteps.count - 1
                                    ? "Next" : "Finish"
                            )
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                        }
                    }

                }
                .frame(width: step.overlayWidth, height: step.overlayHeight)
                .onAppear {
                    if (currentStepIndex == 0 || currentStepIndex == 1)
                        && !hasStartedDelay
                    {
                        hasStartedDelay = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            currentStepIndex += 1
                            hasStartedDelay = false
                        }
                    }
                }
                // Observe changes in `isLocked` to increment `currentStepIndex` when locked
                .onChange(of: isLocked) { newValue in
                    if currentStepIndex == 2 && newValue {
                        currentStepIndex += 1
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {

    BlackOverlayWithHole(
        currentStepIndex: .constant(0), tutorialSteps: tutorialSteps, onTutorialComplete: {},
        isLocked: .constant(false))
}
