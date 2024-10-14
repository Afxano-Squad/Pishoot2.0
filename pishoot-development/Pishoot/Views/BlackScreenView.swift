//
//  BlackScreenView.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 03/07/24.
//

import SwiftUI

struct BlackScreenView: View {
    @Binding var animationProgress: CGFloat
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Hold Still")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                ProgressView(value: animationProgress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color("pishootYellow")))
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: 4)
            }
        }
    }
}

#Preview {
    BlackScreenView(animationProgress: .constant(0.5))
}
