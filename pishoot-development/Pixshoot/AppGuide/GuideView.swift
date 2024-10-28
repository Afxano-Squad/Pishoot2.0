//
//  GuideView.swift
//  Pishoot
//
//  Created by Nadhirul Fatah Ulhaq on 04/07/24.
//

import SwiftUI

struct GuideView: View {
    @Binding var isPresented: Bool
    @State private var currentStepIndex = 0
    @Binding var isAdditionalSettingsOpen : Bool
    @Binding var isMarkerOn: Bool
    
    let steps: [GuideStep]
    
    var body: some View {
        GeometryReader { geometry in
                    if currentStepIndex < steps.count {
                        ZStack {
                            if currentStepIndex != 2 {
                                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                            }
                            
                            VStack {
                                if steps[currentStepIndex].arrowPosition == .top {
                                    VStack {
                                        ArrowView()
                                            .frame(width: 30, height: 30)
                                            .rotationEffect(.degrees(0))
                                            .position(
                                                x: geometry.size.width * steps[currentStepIndex].arrowX,
                                                y: geometry.size.height * steps[currentStepIndex].arrowY
                                            )
                                        
                                        GuidePopUpView(step: steps[currentStepIndex])
                                            .padding(.bottom, 10)
                                            .position(
                                                x: geometry.size.width * steps[currentStepIndex].popUpX,
                                                y: geometry.size.height * steps[currentStepIndex].popUpY
                                            )
                                    }
                                } else {
                                    Spacer()
                                }
                                
                                Spacer()
                                
                                if steps[currentStepIndex].arrowPosition == .bottom {
                                    VStack {
                                        GuidePopUpView(step: steps[currentStepIndex])
                                            .padding(.bottom, 10)
                                            .position(
                                                x: geometry.size.width * steps[currentStepIndex].popUpX,
                                                y: geometry.size.height * steps[currentStepIndex].popUpY
                                            )
                                        
                                        ArrowView()
                                            .frame(width: 30, height: 30)
                                            .rotationEffect(.degrees(180))
                                            .position(
                                                x: geometry.size.width * steps[currentStepIndex].arrowX,
                                                y: geometry.size.height * steps[currentStepIndex].arrowY
                                            )
                                    }
                                } else {
                                    Spacer()
                                }
                            }
                        }
                        .onTapGesture {
                            nextGuide()
                        }
                    } else {
                        Button("Finish") {
                            isPresented = false
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
    
    func nextGuide() {
        if currentStepIndex == 0 {
            isAdditionalSettingsOpen = true
        } else if currentStepIndex == 1 {
            isMarkerOn = true
        } else if currentStepIndex == 4 {
            isAdditionalSettingsOpen = false
            isMarkerOn = false
            UserDefaults.standard.set(true, forKey: "hasSeenGuide")
        }
        currentStepIndex += 1
        if currentStepIndex >= steps.count {
            isPresented = false
        }
    }
}

#Preview {
    GuideView(isPresented: .constant(true), isAdditionalSettingsOpen: .constant(false), isMarkerOn: .constant(false),steps: [GuideStep(id: "Top Control", message: "You can access more to set up by showing what’s in the top control.", highlightFrame: CGRect.zero, arrowPosition: .top, popUpX: 0, popUpY: 0, arrowX: 0, arrowY: 0)])
}
