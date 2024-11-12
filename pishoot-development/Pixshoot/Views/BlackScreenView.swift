//
//  BlackScreenView.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 03/07/24.
//

import SwiftUI

struct BlackScreenView: View {
    @State private var progress = 0.0
        @State private var rotationAngle = 0.0
        @State private var timer: Timer?

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {

                ZStack {
                    // Circular background
                                       Circle()
                                           .stroke(lineWidth: 5)
                                           .foregroundColor(.yellow.opacity(0.3))
                                           .frame(width: 100, height: 100)
                                       
                                       // Circular progress
                                       Circle()
                                           .trim(from: 0, to: progress)
                                           .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                           .foregroundColor(.yellow)
                                           .rotationEffect(.degrees(-90))
                                           .frame(width: 100, height: 100)

                    Text("Hold On")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .onAppear {
                    startProgress()
                }
                .onDisappear {
                    timer?.invalidate() // Stop timer if the view disappears
                }
        
    }
    private func startProgress() {
           progress = 0
           timer?.invalidate() // Reset any existing timer
           timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
               withAnimation(.linear(duration: 1)) {
                   if progress < 1.0 {
                       progress += 0.01 // Increment progress
                   } else {
                       timer?.invalidate() // Stop the timer when progress reaches 1
                   }
               }
           }
       }
}

#Preview {
    BlackScreenView()
}
