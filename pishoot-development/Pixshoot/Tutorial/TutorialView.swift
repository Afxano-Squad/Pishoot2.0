//
//  sample.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 03/11/24.
//

import SwiftUI

struct BlackOverlayWithHole: View {
    @State var currentStepIndex = 0
    let tutorialSteps: [TutorialStep]
    var onTutorialComplete: () -> Void  // Completion handler

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
                                    .frame(width: geometry.size.width, height: geometry.size.height)

                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: step.overlayWidth, height: step.overlayHeight)
                                    .position(x: UIScreen.main.bounds.width / 2 + step.overlayPositionX, y: UIScreen.main.bounds.height / 2 + step.overlayPositionY)
                                    .blendMode(.destinationOut)
                            }
                            .compositingGroup()
                        )
                }

                VStack(spacing: 16) {
                    Image(systemName: step.image)
                        .resizable()
                        .frame(width: step.imageWidth, height: step.imageHeight)

                    Text(step.text)
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .frame(width: 320)
                        .fixedSize(horizontal: false, vertical: true)

                    Button(action: {
                        if currentStepIndex < tutorialSteps.count - 1 {
                            currentStepIndex += 1
                        } else {
                            onTutorialComplete()  // Call completion handler
                        }
                    }) {
                        Text(currentStepIndex < tutorialSteps.count - 1 ? "Next" : "Finish")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                }
                .frame(width: step.overlayWidth, height: step.overlayHeight)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    BlackOverlayWithHole(tutorialSteps: tutorialSteps, onTutorialComplete: {})
}
