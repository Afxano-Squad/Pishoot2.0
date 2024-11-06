//
//  OnBoardingContainerView.swift
//  Pishoot
//
//  Created by Nadhirul Fatah Ulhaq on 03/07/24.
//

import SwiftUI

struct OnBoardingContainerView: View {
    @State private var currentStep = 0
    private let totalSteps = OnBoardingDataModel.data.count + 1  // Include WelcomeOnBoarding as the first step

    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            if currentStep == 0 {
                WelcomeOnBoarding(
                    currentStep: $currentStep, totalSteps: totalSteps,
                    onContinue: {
                        currentStep += 1
                    })
            } else {
                OnBoardingView(
                    data: OnBoardingDataModel.data[currentStep - 1],
                    isLastStep: currentStep == totalSteps - 1,
                    currentStep: $currentStep,
                    totalSteps: totalSteps,
                    onBack: {
                        currentStep -= 1
                    },
                    onContinue: {
                        if currentStep == totalSteps - 1 {
                            completeOnboarding()
                        } else {
                            currentStep += 1
                        }
                    }
                )
                
            }
        }
        .background(Color(red: 0.19, green: 0.19, blue: 0.19))
    }

    private func completeOnboarding() {
        appState.hasCompletedOnboarding = true
    }
}

#Preview {
    OnBoardingContainerView().environmentObject(AppState())
}
