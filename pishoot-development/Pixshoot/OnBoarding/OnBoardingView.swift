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
                VStack(spacing: 0) {
                    if data.imageName == "OnBoarding1" {

                        //                                Image(data.imageName)
                        //                            .resizable()
                        //                                    .scaledToFill()
                        //                                    .frame(width: UIScreen.main.bounds.width, height: geometry.size.height * 0.5) // Adjust height to fit design
                        //                                    .clipped()
                        //                                    .ignoresSafeArea()
                        Rectangle()
                            .foregroundColor(.clear)

                            .background(
                                Image(data.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    //                                                            .clipped()
                                    .ignoresSafeArea()
                            )

                    }else if data.imageName == "OnBoarding2" {
                        
                                Image(data.imageName)
                                    .resizable()
                                    .scaledToFill()
//                                    .frame(width: 393, height: 452)
//                                    .clipped()
                                    .ignoresSafeArea()
                    }
                    else {
                        Image(data.imageName)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(Color("Primary"))

                VStack(alignment: .leading /*, spacing: 38*/) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(data.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .lineSpacing(8)

                        Text(data.description)
                            .font(.body)
                            .foregroundColor(.white)
                            //                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .lineSpacing(12)
                    }
                    //                    .frame(maxWidth: .infinity)

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
                                            ? Color("Primary") : Color.clear
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
                            Text("Back")
                                .font(.body)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(
                                    Color("Primary"))
                        }
                        .padding(10)
                        .frame(width: 103, alignment: .center)
                        .cornerRadius(9)
                        .onTapGesture {
                            onBack()
                        }

                        VStack(alignment: .center, spacing: 10) {
                            Text(isLastStep ? "Get Started" : "Continue")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(Color("Secondary"))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color("Primary"))
                        .cornerRadius(9)
                        .onTapGesture {
                            onContinue()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 372)
                .padding(.top, 18)
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .topLeading)

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
