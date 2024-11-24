//
//  ButtonLockGryos.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 30/10/24.
//

import SwiftUI
import ARKit
import RealityKit

struct ButtonLockGyros: View {
    @ObservedObject var gyroViewModel: GyroViewModel
    @ObservedObject var frameViewModel: FrameViewModel
    @ObservedObject var acclerometerViewModel: AccelerometerViewModel
    @Binding var isLocked: Bool
    
    var model = FrameModel()
    var arView: ARView
    
    
    var body: some View {
        Button(action: {
            frameViewModel.toggleFrame(at: arView)
            withAnimation(.easeInOut(duration: 0.4)) {
                isLocked.toggle()
            }
            if isLocked {
                acclerometerViewModel.lockAcceleration()
                
            } else {
                acclerometerViewModel.resetAcceleration()
            }
            
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isLocked ? Color("Primary") : .white, lineWidth: 2)
                    .frame(width: 57, height: 57)
                
                // Overlay both icons and control their visibility
                Image(systemName: "lock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isLocked ? 30 : 0, height: 43)
                    .foregroundColor(Color("Primary"))
                    .opacity(isLocked ? 1 : 0)
                    .animation(.easeInOut(duration: 0.4), value: isLocked)
                
                Image(systemName: "lock.open")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isLocked ? 0 : 30, height: 43)
                    .foregroundColor(.white)
                    .opacity(isLocked ? 0 : 1)
                    .animation(.easeInOut(duration: 0.4), value: isLocked)
            }
            .rotationEffect(gyroViewModel.rotationAngle)
            .animation(
                .easeInOut(duration: 0.3), value: gyroViewModel.rotationAngle)
        }
        .animation(
            .spring(response: 0.4, dampingFraction: 0.6), value: isLocked)
        
    }
}
