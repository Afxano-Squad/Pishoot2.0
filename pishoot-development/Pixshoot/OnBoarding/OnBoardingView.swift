//
//  OnBoardingView.swift
//  Pishoot
//
//  Created by Nadhirul Fatah Ulhaq on 03/07/24.
//

import SwiftUI

struct OnBoardingView: View {
    var data: OnBoardingDataModel
    var isLastStep: Bool
    @Binding var currentStep: Int
    var totalSteps: Int
    var onBack: () -> Void
    var onContinue: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if data.imageName == "OnBoarding1" {
                    VStack {
                        Image(data.imageName)
                            .resizable()
                            .scaledToFill()
                            .padding(.bottom, 40)
                            .frame(width: geometry.size.width * 0.95)

                    }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 0.55
                    )
                    .background(Color("Primary"))
                } else if data.imageName == "OnBoarding2" {

                    Image(data.imageName)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height * 0.55)

                } else {
                    VStack {
                        Image(data.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height * 0.55)
                    }
                    .background(Color("Primary"))
                }

                VStack(alignment: .leading /*, spacing: 38*/) {

                    VStack(alignment: .center, spacing: 15) {
                        Text(data.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)  // Centers the title text
                            .frame(maxWidth: .infinity)  // Expands to fill available width
                            .lineLimit(nil)  // Allows unlimited lines

                        Text(data.description)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)  // Centers the text
                            .frame(alignment: .center)
                            .lineSpacing(10)
                    }

                    Spacer()

                    // Progress Indicator
                    HStack(spacing: 10) {
                        Spacer()
                        ForEach(0..<totalSteps, id: \.self) { index in
                            ZStack {
                                Circle()
                                    .fill(Color("BackgroundProgress"))
                                    .frame(
                                        width: index == currentStep ? 14 : 10,
                                        height: index == currentStep ? 14 : 10
                                    )
                                    .shadow(
                                        color: index == currentStep
                                            ? Color.blue.opacity(0.4)
                                            : Color.clear, radius: 5)

                                Circle()
                                    .fill(
                                        index < currentStep + 1
                                            ? Color("Button") : Color.clear
                                    )
                                    .frame(
                                        width: index == currentStep ? 8.4 : 6,
                                        height: index == currentStep ? 8.4 : 6
                                    )
                                    .animation(.easeInOut, value: currentStep)
                            }
                        }
                        Spacer()
                    }
                    .padding(.bottom, 10)

                    HStack(alignment: .center, spacing: 3) {

                        VStack(alignment: .center, spacing: 10) {
                            Button(action: {
                                onBack()
                            }) {
                                Text("Back")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("Button"))
                            }
                            .padding(10)
                            .frame(width: 103, alignment: .center)
                            .background(Color.clear)
                            .cornerRadius(9)
                        }

                        VStack(alignment: .center, spacing: 10) {
                            Button(action: {
                                onContinue()
                            }) {
                                Text(isLastStep ? "Get Started" : "Continue")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("Secondary"))
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color("Button"))
                            .cornerRadius(9)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                //                .frame(height: 372)
                .padding(.top, 10)
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
                //                .frame(maxWidth: .infinity, alignment: .topLeading)

                Spacer()
            }
            .background(Color("Secondary"))

            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold = geometry.size.width * 0.25
                        if value.translation.width > threshold {
                            withAnimation { onBack() }
                        } else if value.translation.width < -threshold {
                            withAnimation { onContinue() }
                        }
                    }
            )
        }

    }
}

#Preview {
    OnBoardingView(
        data: OnBoardingDataModel.data[1],
        isLastStep: false,
        currentStep: .constant(1),
        totalSteps: 4,
        onBack: {},
        onContinue: {}
    )
}
