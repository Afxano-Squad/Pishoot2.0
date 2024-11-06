//
//  OnBView.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 05/11/24.
//

import SwiftUI

struct OnBoardingViewN: View {
    var data: OnBoardingDataModel
    var isLastStep: Bool
    @Binding var currentStep: Int
    var totalSteps: Int
    var onBack: () -> Void
    var onContinue: () -> Void
    
    var body: some View {
        VStack {
            // Image and Title section
            Image(data.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 300) // Adjust height as needed
            
           
            // Content Section
            VStack(alignment: .leading, spacing: 10) {
                Text(data.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(data.description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(Color("Secondary")) // Replace with your custom color
            .cornerRadius(16)
            .padding([.leading, .trailing])
            .ignoresSafeArea()
            
            Spacer()
            
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
            
            
            HStack(alignment: .center, spacing: 3) {
                if !isLastStep {
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
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color("Primary")) // Replace with your custom color
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    OnBoardingViewN(
        data: OnBoardingDataModel.data[0],
        isLastStep: false,
        currentStep: .constant(1),
        totalSteps: 4,
        onBack: {},
        onContinue: {}
    )
}
