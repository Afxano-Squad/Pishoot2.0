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
    var onBack: () -> Void
    var onContinue: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    VStack {
                        Spacer()
                        
                        Rectangle()
                            .foregroundColor(.clear)
                        
                            .background(
                                Image(data.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                            )
                    }
                    .background(Color(red: 0.95, green: 0.86, blue: 0.04))
                }
                
                VStack(alignment: .leading, spacing: 38) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(data.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        Text(data.description)
                            .font(.body)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .padding(0)
                    
                    
                    ProgressView(value: data.progress, total: 1)
                        .progressViewStyle(.linear)
                        .tint(Color("pishootYellow"))
                        .background(.black)
                    
                    HStack(alignment: .center, spacing: 3) {
                        if !isLastStep {
                            VStack(alignment: .center, spacing: 10) {
                                Text("Back")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.95, green: 0.86, blue: 0.04))
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
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color(red: 0.95, green: 0.86, blue: 0.04))
                        .cornerRadius(9)
                        .onTapGesture {
                            onContinue()
                        }
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(37)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Spacer()
            }
            .background(Color(red: 0.19, green: 0.19, blue: 0.19))
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold = geometry.size.width * 0.25
                        if value.translation.width > threshold {
                            withAnimation {
                                onBack()
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation {
                                onContinue()
                            }
                        }
                    }
            )
        }
        
    }
}

#Preview {
    OnBoardingView(data: OnBoardingDataModel.data[0], isLastStep: false, onBack: {}, onContinue: {})
}
