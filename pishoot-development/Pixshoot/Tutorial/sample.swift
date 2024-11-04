////
////  sample.swift
////  Pixshoot
////
////  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 03/11/24.
////
//
//import SwiftUI
//
//import SwiftUI
//
//struct BlackOverlayWithHole: View {
//    
//    @State private var currentStepIndex = 0  // Track the current step
//    let tutorialSteps: [TutorialStep]
//
//    var body: some View {
//           ZStack {
//               Color.white  // Background color (replace with main content if needed)
//
//               if currentStepIndex < tutorialSteps.count {
//                   let step = tutorialSteps[currentStepIndex]  // Current step details
//
//                   GeometryReader { geometry in
//                       ZStack {
//                           // Black overlay with a transparent rounded rectangle (dynamic size and position)
//                           Color.black
//                               .opacity(0.7)
//                               .mask(
//                                   ZStack {
//                                       Rectangle()
//                                           .frame(width: geometry.size.width, height: geometry.size.height)
//
//
//                                       RoundedRectangle(cornerRadius: 25)
//                                           .frame(width: tutorialSteps[currentStepIndex].overlayWidth, height: tutorialSteps[currentStepIndex].overlayHeight)
//                                           .position(step.overlayPosition)
//                                           .blendMode(.destinationOut)
//                                   }
//                                   .compositingGroup()
//                               )
//                               .edgesIgnoringSafeArea(.all)
//
//                           // Align VStack with the overlay's hole position
//                           VStack(spacing: 16) {
//                               Image(systemName: tutorialSteps[currentStepIndex].image)
//                                   .resizable()
//                                   .frame(width: step.imageWidth, height: step.imageHeight)  // Dynamic image size
//
//                               Text(step.text)
//                                   .foregroundColor(.black)
//                                   .padding()
//                                   .background(Color.orange)
//                                   .cornerRadius(10)
//
//                               Button(action: {
//                                   // Move to next step or finish tutorial
//                                   if currentStepIndex < tutorialSteps.count - 1 {
//                                       currentStepIndex += 1
//                                   } else {
//                                       // Action on finish (e.g., hide overlay or perform final step)
//                                       // showOverlay = false  // Uncomment if you want to hide the overlay
//                                   }
//                               }) {
//                                   Text(currentStepIndex < tutorialSteps.count - 1 ? "Next" : "Finish")
//                                       .fontWeight(.bold)
//                                       .foregroundColor(.white)
//                                       .padding()
//                                       .background(Color.orange)
//                                       .cornerRadius(10)
//                               }
//                           }
//                           // Position VStack within the overlay's transparent area
//                           .frame(width: step.overlayWidth, height: step.overlayHeight)
//                           .position(step.overlayPosition)
//                       }
//                   }
//               }
//           }
//           .edgesIgnoringSafeArea(.all)
//       }
//}
//
//
//#Preview Provider{
//    BlackOverlayWithHole(tutorialSteps: [TutorialStep])
//}
