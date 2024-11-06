//
//  progresview.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 05/11/24.
//

import SwiftUI

struct DotProgressBar: View {
    let totalSteps: Int  // Total number of dots
    @State private var currentStep = 0  // Current progress step, starts at 0

    var body: some View {
        VStack {
            // Dot Progress Bar
            HStack(spacing: 10) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(
                                width: index == currentStep ? 20 : 14,  // Larger size for current step
                                height: index == currentStep ? 20 : 14
                            )
                            .shadow(
                                color: index == currentStep
                                    ? Color.blue.opacity(0.4) : Color.clear,
                                radius: 5, x: 0, y: 0)

                        Circle()
                            .fill(
                                index < currentStep + 1 ? Color.blue : Color.clear
                            )
                            .frame(
                                width: index == currentStep ? 18 : 12,
                                height: index == currentStep ? 18 : 12
                            )
                            .animation(.easeInOut, value: currentStep)

                    }
                }
            }
            .padding()

            // Next and Previous Buttons
            HStack {
                Button(action: {
                    if currentStep > 0 {
                        currentStep -= 1
                    }
                }) {
                    Text("Previous")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .disabled(currentStep == 0)  // Disable if at the beginning

                Spacer()

                Button(action: {
                    if currentStep < totalSteps {
                        currentStep += 1
                    }
                }) {
                    Text("Next")
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
                .disabled(currentStep == totalSteps)  // Disable if at the end
            }
            .padding(.horizontal)
        }
    }
}

struct DotProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        DotProgressBar(totalSteps: 5)  // Example with 5 dots
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

#Preview {
    DotProgressBar(totalSteps: 5)  // Example with 5 dots
        .padding()
        .previewLayout(.sizeThatFits)
}
