//
//  OnBoardingView.swift
//  Pishoot
//
//  Created by Nadhirul Fatah Ulhaq on 02/07/24.
//

import SwiftUI

struct WelcomeOnBoarding: View {
    @State private var animate = false
    @State private var progress: Float = 0.20
    var onContinue: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                Color(Color(red: 0.95, green: 0.86, blue: 0.04))
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 38) {
                    HStack(alignment: .top, spacing: 15) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 21, height: 145)
                            .background(.black)
                            .cornerRadius(75)
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 0)
                        
                        Image("shoot")
                            .frame(width: 91.62347, height: 93.61382)
                            .rotationEffect(Angle(degrees: animate ? 370 : 0))
                            .animation(
                                .linear(duration: 1)
                                .repeatForever(autoreverses: false),
                                value: animate
                            )
                            .onAppear {
                                withAnimation {
                                    animate.toggle()
                                }
                            }
                    }
                    .padding(0)
                    .padding(.top, 180)
                    
                    VStack(alignment: .leading, spacing: 19) {
                        Text("Welcome to Pishoot")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        Text("Say goodbye to the hassle of asking strangers to retake your photo multiple times and hello to stunning shots in just one session!")
                            .font(.body)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .padding(0)
                    
                    ProgressView(value: progress)
                        .progressViewStyle(.linear)
                        .tint(.black)
                        .background(Color(red: 0.6, green: 0.58, blue: 0))
                        
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("Continue")
                            .font(.body)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.95, green: 0.86, blue: 0.04))
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(red: 0.19, green: 0.19, blue: 0.19))
                    .cornerRadius(9)
                    .onTapGesture {
                        onContinue()
                    }
                }
                .padding(0)
                .frame(width: 310, alignment: .topLeading)
            }
        }
    }
}

#Preview {
        WelcomeOnBoarding(onContinue: {})
}
