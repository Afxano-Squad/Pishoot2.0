//
//  BottomBarView.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import SwiftUI

struct BottomBarView: View {
    var lastPhoto: UIImage?
    var captureAction: () -> Void
    var openPhotosApp: () -> Void
    @Binding var isCapturing: Bool
    @Binding var animationProgress: CGFloat
    @ObservedObject var gyroViewModel: GyroViewModel  // This must be present
    @Binding var isLocked: Bool

    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                PhotoThumbnailView(
                    lastPhoto: lastPhoto, openPhotosApp: openPhotosApp)
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
                    gyroViewModel: gyroViewModel,
                    isLocked: $isLocked)
                Spacer()
            }

            HStack(alignment: .center) {
                Spacer()
                ButtonLockGyros(
                    gyroViewModel: gyroViewModel, isLocked: $isLocked)
            }
            .padding()
            .padding(.bottom)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

#Preview {
    BottomBarView(
        lastPhoto: nil, captureAction: {}, openPhotosApp: {},
        isCapturing: .constant(false), animationProgress: .constant(0.5), gyroViewModel: GyroViewModel(),
        isLocked: .constant(false))
}
