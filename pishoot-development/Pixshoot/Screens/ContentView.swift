//
//  ContentView.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import ARKit
import RealityKit
import SwiftUI

struct ContentView: View {

    @StateObject private var gyroViewModel = GyroViewModel()
    @StateObject private var cameraViewModel = CameraViewModel()
    @StateObject private var frameViewModel: FrameViewModel
    @StateObject private var acclerometerViewModel = AccelerometerViewModel()

    @State private var lastPhotos: [UIImage] = []
    @State private var isGridOn: Bool = false
    @Environment(\.scenePhase) private var scenePhase

    @State private var showGuide = !UserDefaults.standard.bool(
        forKey: "hasCompletedTutorial")
    @State private var highlightFrame = CGRect.zero
    @State private var guideStepIndex = 0
    @State private var animationProgress: CGFloat = 0
    @State private var isDeviceSupported: Bool = false
    @State private var isShowingBlackScreen: Bool = false
    @State private var isLocked = false

    @EnvironmentObject var appState: AppState
    @State private var currentStepIndex = 0

    @State private var arView = ARView(frame: .zero)

    //    @State private var isCapturingPhoto = false

    init() {
        let arViewInstance = ARView(frame: .zero)
        _arView = State(initialValue: arViewInstance)
        _frameViewModel = StateObject(
            wrappedValue: FrameViewModel(arView: arViewInstance))
    }

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

                                ARViewContainer(arView: $arView)
                                    .edgesIgnoringSafeArea(.all)

                                if frameViewModel.model.anchor != nil {
                                    GreenOverlay(
                                        overlayColor: frameViewModel.model
                                            .overlayColor
                                    )
                                    .transition(.scale)
                                    .animation(
                                        .easeInOut,
                                        value: frameViewModel.model.anchor)
                                }

                                AcclerometerView(
                                    accleroViewModel: acclerometerViewModel,
                                    gyroViewModel: gyroViewModel,
                                    isLocked: $isLocked)
                                GuidanceTextView(
                                    gyroViewModel: gyroViewModel,
                                    accleroViewModel: acclerometerViewModel)

                                VStack {
                                    Spacer()
//                                    if appState.hasCompletedTutorial {
//                                        MainAdditionalSetting(
//                                            isGridOn: $isGridOn,
//                                            toggleFlash: {
//                                                cameraViewModel.toggleFlash()
//                                            },
//                                            isFlashOn: cameraViewModel
//                                                .isFlashOn,
//                                            cameraViewModel: cameraViewModel,
//                                            gyroViewModel: gyroViewModel)
//                                    }

                                    BottomBarView(
                                        lastPhoto: lastPhotos.first,
                                        captureAction: {
                                            isShowingBlackScreen = true
                                            if !appState.hasCompletedTutorial && currentStepIndex == tutorialSteps.count - 1 {
                                                completeTutorial()
                                            }
                                                    frameViewModel.capturePhoto()
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                                                        isShowingBlackScreen = false
                                                    }
                                        },
                                        openPhotosApp: {
                                            PhotoLibraryHelper.openPhotosApp()
                                        },
                                        isCapturing: $cameraViewModel
                                            .isCapturingPhoto,
                                        animationProgress: $animationProgress,
                                        gyroViewModel: gyroViewModel,
                                        frameViewModel: frameViewModel,
                                        acclerometerViewModel:
                                            acclerometerViewModel,
                                        isLocked: $isLocked, arView: arView
                                    )
                                    .padding(.top, 10)
                                    .padding(.bottom, 20)
                                }

                            }
                            
                            if isShowingBlackScreen{
                                BlackScreenView()
                                    .edgesIgnoringSafeArea(.all)
                            }

                            if !appState.hasCompletedTutorial {
                                BlackOverlayWithHole(
                                    currentStepIndex: $currentStepIndex,
                                    tutorialSteps: tutorialSteps,
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
                    } else {
                        Text("Camera not available")
                    }
                }
            } else {
                UnsupportedDeviceView()
            }
        }
        .statusBar(hidden: true)
        .onAppear {
            let tutorialCompleted = UserDefaults.standard.bool(forKey: "hasCompletedTutorial")
            print("Tutorial Completed Status: \(tutorialCompleted)")
            showGuide = !tutorialCompleted
            isDeviceSupported = checkDeviceCapabilities()
        }

        .onChange(of: scenePhase) {
            handleScenePhaseChange(scenePhase)

        }

        .onAppear {
            // MODIFIED: Mengecek dukungan perangkat dan memulai sesi kamera di sini
            print("Checking device capabilities...")
            isDeviceSupported = checkDeviceCapabilities()
            if isDeviceSupported {
                print("Device supported, starting camera session...")
                //                        cameraViewModel.startSession()
                PhotoLibraryHelper.fetchLastPhoto { image in
                    if let image = image {
                        self.lastPhotos = [image]
                    }
                }
            }
        }

        .onAppear {
            isDeviceSupported = checkDeviceCapabilities()
        }

    }

    private func completeTutorial() {
        showGuide = false
        appState.hasCompletedTutorial = true
        UserDefaults.standard.set(true, forKey: "hasCompletedTutorial")
        UserDefaults.standard.synchronize() // Optional, ensures immediate saving
    }

    // Function to display grid overlay when isGridOn is active
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
                //                cameraViewModel.startSession()
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
            print("Unkown scene phase")
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
        .builtInWideAngleCamera, for: .video, position: .back
    )
    let has2xZoom = wideAngleCamera?.maxAvailableVideoZoomFactor ?? 1.0 >= 2.0

    return hasUltraWide && has2xZoom

}
