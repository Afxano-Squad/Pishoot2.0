//
//  ContentView.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    @StateObject private var gyroViewModel = GyroViewModel()
    @StateObject private var acclerometerViewModel = AcclerometerViewModel()
    @StateObject private var cameraViewModel = CameraViewModel()
    @State private var lastPhotos: [UIImage] = []
    @State var isMarkerOn: Bool = false
    @State var isGridOn: Bool = false  // Status grid overlay
    @State var isAdditionalSettingsOpen: Bool = false
    @Environment(\.scenePhase) private var scenePhase

    @State private var showGuide = !UserDefaults.standard.bool(forKey: "hasCompletedTutorial")

    @State private var highlightFrame = CGRect.zero
    @State private var guideStepIndex = 0
    @State private var chevronButtonTapped = false
    @State var animationProgress: CGFloat = 0
    @State private var isDeviceSupported: Bool = false
    @State private var isLocked = false

    // Tutorial
    @EnvironmentObject var appState: AppState
    @State var currentStepIndex = 0

    var body: some View {
        Group {
            if isDeviceSupported {
                VStack {
                    if let session = cameraViewModel.session {
                        GeometryReader { geometry in
                            let width = geometry.size.width
                            let height = width * 16 / 9
                            let verticalPadding =
                                (geometry.size.height - height) / 6

                            ZStack {

                                VStack {
                                    Spacer()

                                    CameraPreviewView(
                                        session: session,
                                        countdown: $cameraViewModel.countdown,
                                        isGridOn: $isGridOn
                                    )
                                    .frame(width: width, height: height)
                                    .clipped()
                                    .overlay(
                                        BlackScreenView()
                                            .opacity(
                                                cameraViewModel
                                                    .isBlackScreenVisible
                                                    ? 1 : 0)
                                    )

                                    Spacer()
                                }
                                .padding(.top, verticalPadding)
                                .padding(.bottom, verticalPadding + 12)

                                if isGridOn {
                                    RuleOf3GridView(
                                        lineColor: .white, lineWidth: 0.5
                                    )
                                    .frame(width: width, height: height)
                                    .padding(.top, verticalPadding)
                                    .padding(.bottom, verticalPadding + 10)
                                }
                                
                                AcclerometerView(acleroViewModel: acclerometerViewModel, isLocked: $isLocked)
                                VStack {
                                    Spacer()
                                    if appState.hasCompletedTutorial{
                                        MainAdditionalSetting(
//                                            selectedZoomLevel: $cameraViewModel
//                                                .selectedZoomLevel,
//                                            isMarkerOn: $isMarkerOn,
                                            isGridOn: $isGridOn,
//                                            isMultiRatio: $cameraViewModel
//                                                .isMultiRatio,
                                            toggleFlash: {
                                                cameraViewModel.toggleFlash()
                                            },
                                            isFlashOn: cameraViewModel.isFlashOn,
//                                            isMultiframeOn: false,
                                            cameraViewModel: cameraViewModel,
                                            gyroViewModel: gyroViewModel)
                                    }
                                    

                                    BottomBarView(
                                        lastPhoto: lastPhotos.first,
                                        captureAction: {
                                            if !appState.hasCompletedTutorial && currentStepIndex == tutorialSteps.count - 1 {
                                                    completeTutorial()
                                                }
                                                cameraViewModel.capturePhotos { images in
                                                    self.lastPhotos = images
                                                }
                                        },
                                        openPhotosApp: {
                                            PhotoLibraryHelper.openPhotosApp()
                                        },
                                        isCapturing: $cameraViewModel
                                            .isCapturingPhoto,
                                        animationProgress: $animationProgress,
                                        gyroViewModel: gyroViewModel, acclerometerViewModel: acclerometerViewModel,
                                        isLocked: $isLocked
                                    )
                                    .padding(.top, 10)
                                    .padding(.bottom, 20)
                                }

                HStack {
                    Spacer()
                    Spacer()

                    Button(action: {
                        guard !isCapturingPhoto else { return }
                        isCapturingPhoto = true
                        frameViewModel.capturePhoto(from: arView) {
                            isCapturingPhoto = false
                        }
                    }) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .frame(width: 70, height: 70)
                            )
                    }


                    Spacer()
                    Button(action: {
                        frameViewModel.toggleFrame(at: arView)
                    }) {
                        Image(systemName: "lock.square.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }

                    Spacer()
                }
                .padding(.bottom, 50)
            }
        }

    }
}
