//
//  BottomBarView.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import SwiftUI
import RealityKit
import ARKit

struct BottomBarView: View {
    var lastPhoto: UIImage?
    var captureAction: () -> Void
    var openPhotosApp: () -> Void
    @Binding var isCapturing: Bool
    @Binding var animationProgress: CGFloat
    @ObservedObject var gyroViewModel: GyroViewModel  // This must be present]
    @ObservedObject var frameViewModel: FrameViewModel
    @ObservedObject var acclerometerViewModel: AccelerometerViewModel
    @Binding var isLocked: Bool
    var arView: ARView
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                PhotoThumbnailView(
                    lastPhoto: lastPhoto, openPhotosApp: openPhotosApp, gyroViewModel: gyroViewModel)
                Spacer()
            }
            .padding()
            .padding(.bottom)
            
            HStack {
                Spacer()
                CaptureButton(
                    action: captureAction,
                    isCapturing: $isCapturing,
                    animationProgress: $animationProgress,
                    gyroViewModel: gyroViewModel, frameViewModel: frameViewModel,
                    accelerometerViewModel: acclerometerViewModel,
                    isLocked: $isLocked)
                .disabled(!acclerometerViewModel.isAcclero)
                .opacity(acclerometerViewModel.isAcclero ? 1.0 : 0.5)
                Spacer()
            }
            
            HStack(alignment: .center) {
                Spacer()
                ButtonLockGyros(
                    gyroViewModel: gyroViewModel, frameViewModel: frameViewModel, acclerometerViewModel: acclerometerViewModel, isLocked: $isLocked, arView: arView)
            }
            .padding()
            .padding(.bottom)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}
//
//#Preview {
//    BottomBarView(
//        lastPhoto: nil, captureAction: {}, openPhotosApp: {},
//        isCapturing: .constant(false), animationProgress: .constant(0.5), gyroViewModel: GyroViewModel(), frameViewModel: FrameViewModel(),
//        isLocked: .constant(false))
//}
