//
//  OnBoardingView.swift
//  Pishoot
//
//  Created by Nadhirul Fatah Ulhaq on 02/07/24.
//

import SwiftUI

struct WelcomeOnBoarding: View {
        @Binding var currentStep: Int
        var totalSteps: Int
        var onContinue: () -> Void

    var body: some View {
        VStack {
            Spacer()

            // Logo
            Image("Logo")  // Placeholder, replace with your custom image
                .resizable()
                .scaledToFit()
                .frame(width: 203, height: 277)
                .padding(.bottom, 38)


            // Title
            Text("Welcome to Pixshoot")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.bottom, 2)

            // Subtitle
            Text("Get shot in any scale with just one click")
                .font(.title2)
                .frame(width: 267)
                .foregroundColor(Color("Secondary"))
                .multilineTextAlignment(.center)

            

            // Progress Indicator
                        HStack(spacing: 10) {
                            ForEach(0..<totalSteps, id: \.self) { index in
                                ZStack {
                                    Circle()
                                        .fill(Color("BackgroundProgress"))
                                        .frame(
                                            width: index == currentStep ? 14 : 10,
                                            height: index == currentStep ? 14 : 10)
                                        .shadow(color: index == currentStep ? Color.blue.opacity(0.4) : Color.clear, radius: 5)

                                    Circle()
                                        .fill(index < currentStep + 1 ? Color("Button") : Color.clear)
                                        .frame(width: index == currentStep ? 8.4 : 6,
                                               height: index == currentStep ? 8.4 : 6)
                                        .animation(.easeInOut, value: currentStep)
                                }
                            }
                        }
                        .padding(.bottom, 16)
                        .padding(.top, 99)

            // Continue Button
            Button(action: {
                onContinue()
            }) {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundColor(Color("Secondary"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("Button"))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
        .background(Color("Primary").edgesIgnoringSafeArea(.all))  // Customize color to match background color
    }
}

#Preview {
    WelcomeOnBoarding(currentStep: .constant(0), totalSteps: 4, onContinue: {})
}
