//
//  CaptureButton.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import SwiftUI

struct CaptureButton: View {
    var action: () -> Void
    @Binding var isCapturing: Bool
    @Binding var animationProgress: CGFloat
    
    var body: some View {
        Button(action: {
            self.action()
            withAnimation(.linear(duration: 0.5)) {
                self.animationProgress = 1
            }
        }) {
            ZStack {
                if !isCapturing {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 60, height: 60)
                }
                
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 75, height: 75)
                
                Circle()
                    .trim(from: 0, to: animationProgress)
                    .stroke(Color("pishootYellow"), lineWidth: 10)
                    .frame(width: 65, height: 65)
                    .rotationEffect(Angle(degrees: -90))
            }
        }
        .onChange(of: isCapturing) { oldValue, newValue in
            if !newValue {
                withAnimation(.linear(duration: 0.3)) {
                    self.animationProgress = 0
                }
            }
        }
    }
}

#Preview {
    CaptureButton(action: {}, isCapturing: .constant(false),animationProgress: .constant(0.5))
}
