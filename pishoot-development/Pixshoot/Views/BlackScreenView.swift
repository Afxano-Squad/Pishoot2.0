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
    let duration: Double = 5.2  // Durasi total progres selesai dalam detik

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {

                ZStack {
                    // Circular background
                    Circle()
                        .stroke(lineWidth: 13)
                        .foregroundColor(.yellow.opacity(0.3))
                        .frame(width: 250, height: 250)

                    // Circular progress
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            style: StrokeStyle(lineWidth: 13, lineCap: .round)
                        )
                        .foregroundColor(.yellow)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 250, height: 250)

                    Text("Hold On")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        
        }
        .onAppear {
            startProgress()
        }
        .onDisappear {
            timer?.invalidate()  // Stop timer if the view disappears
        }

    }
    private func startProgress() {
        progress = 0
        timer?.invalidate()  // Reset any existing timer
        let step = 0.1  // Langkah inkrementasi progress
        let interval = duration * step  // Interval timer (sesuai durasi)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true)
        { _ in
            withAnimation(.linear(duration: interval)) {
                if progress < 1 {
                    progress += step
                } else {
                    timer?.invalidate()  // Stop timer when progress reaches 1
                }
            }
        }
    }
}

#Preview {
    BlackScreenView()
}
