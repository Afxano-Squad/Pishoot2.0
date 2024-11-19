//
//  ContentView.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import AVFoundation
import SwiftUI

struct ContentView: View {
    @StateObject private var gyroViewModel = GyroViewModel()
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

                                        RollView()

                                VStack {
                                    Spacer()
                                    if appState.hasCompletedTutorial{
                                        MainAdditionalSetting(
                                            selectedZoomLevel: $cameraViewModel
                                                .selectedZoomLevel,
                                            isMarkerOn: $isMarkerOn,
                                            isGridOn: $isGridOn,
                                            isMultiRatio: $cameraViewModel
                                                .isMultiRatio,
                                            toggleFlash: {
                                                cameraViewModel.toggleFlash()
                                            },
                                            isFlashOn: cameraViewModel.isFlashOn,
                                            isMultiframeOn: false,
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
                                        gyroViewModel: gyroViewModel,
                                        isLocked: $isLocked
                                    )
                                    .padding(.top, 10)
                                    .padding(.bottom, 20)
                                }

                                GyroView(
                                    gyroViewModel: gyroViewModel,
                                    isMarkerOn: $isMarkerOn)

                                if !appState.hasCompletedTutorial {
                                    BlackOverlayWithHole(
                                        currentStepIndex: $currentStepIndex, tutorialSteps: tutorialSteps,
                                        onTutorialComplete: {
                                            showGuide = false
                                        },
                                        isLocked: $isLocked
                                    )
                                    .frame(
                                        width: UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.height
                                    )
                                    .position(
                                        x: UIScreen.main.bounds.width / 2,
                                        y: UIScreen.main.bounds.height / 2
                                    )
                                    .ignoresSafeArea()
                                }
                            }
                        }
                    } else {
                        Text("Camera not available")
                    }
                }
            } else {
                UnsupportedDeviceView()
            }
        }
        .statusBar(hidden: true)
        .onChange(of: appState.hasCompletedTutorial) { hasCompleted in
            showGuide = !hasCompleted
        }
        
        .onChange(of: scenePhase) {
            handleScenePhaseChange(scenePhase)
        }
        .onAppear {
            isDeviceSupported = checkDeviceCapabilities()
        }

    }

    private func completeTutorial() {
        showGuide = false
        appState.hasCompletedTutorial = true
        UserDefaults.standard.set(true, forKey: "hasCompletedTutorial")
    }

    // Fungsi overlayGrid untuk menampilkan grid overlay saat isGridOn aktif
    func overlayGrid() -> some View {
        ZStack {
            if isGridOn {
                RuleOf3GridView(lineColor: .white, lineWidth: 1)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }

    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            cameraViewModel.notifyPhoneActive()
            print("App became active")
            if isDeviceSupported {
                cameraViewModel.startSession()
                PhotoLibraryHelper.fetchLastPhoto { image in
                    if let image = image {
                        self.lastPhotos = [image]
                    }
                }
            }
        case .inactive:
            cameraViewModel.notifyPhoneInactive()
            print("App became inactive")
        case .background:
            cameraViewModel.notifyPhoneInactive()
            print("App went to background")
            if isDeviceSupported {
                cameraViewModel.stopSession()
            }
        @unknown default:
            print("Unknown scene phase")
        }
    }
}

func checkDeviceCapabilities() -> Bool {
    let deviceTypes: [AVCaptureDevice.DeviceType] = [
        .builtInWideAngleCamera,
        .builtInUltraWideCamera,
    ]

    let discoverySession = AVCaptureDevice.DiscoverySession(
        deviceTypes: deviceTypes,
        mediaType: .video,
        position: .back
    )

    let hasUltraWide = discoverySession.devices.contains {
        $0.deviceType == .builtInUltraWideCamera
    }

    let wideAngleCamera = AVCaptureDevice.default(
        .builtInWideAngleCamera, for: .video, position: .back)
    let has2xZoom = wideAngleCamera?.maxAvailableVideoZoomFactor ?? 1.0 >= 2.0

    return hasUltraWide && has2xZoom
}

#Preview {
    ContentView()
}
