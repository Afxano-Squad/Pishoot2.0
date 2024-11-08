//
//  ContentView.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import AVFoundation
import SwiftUI

struct dumy: View {
    @StateObject private var gyroViewModel = GyroViewModel()
    @StateObject private var cameraViewModel = CameraViewModel()
    @State private var lastPhotos: [UIImage] = []
    @State var isMarkerOn: Bool = false
    @State var isGridOn: Bool = false
    @State var isAdditionalSettingsOpen: Bool = false
    @Environment(\.scenePhase) private var scenePhase

    @State private var showGuide =
        UserDefaults.standard.bool(forKey: "hasSeenGuide") == false
    @State private var highlightFrame = CGRect.zero
    @State private var guideStepIndex = 0
    @State private var chevronButtonTapped = false
    @State var animationProgress: CGFloat = 0
    @State private var isLocked = false

    // Tutorial
    @EnvironmentObject var appState: AppState
    let tutorialSteps: [TutorialStep]

    var body: some View {
        VStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = width * 16 / 9
                let verticalPadding = (geometry.size.height - height) / 6

                ZStack {
                    VStack {
                        Spacer()

                        BottomBarView(
                            lastPhoto: lastPhotos.first,
                            captureAction: {
                                cameraViewModel.capturePhotos { images in
                                    self.lastPhotos = images
                                }
                            },
                            openPhotosApp: {
                                PhotoLibraryHelper.openPhotosApp()
                            },
                            isCapturing: $cameraViewModel.isCapturingPhoto,
                            animationProgress: $animationProgress,
                            gyroViewModel: gyroViewModel,
                            isLocked: $isLocked
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    }

                    GyroView(
                        gyroViewModel: gyroViewModel,
                        isMarkerOn: $isMarkerOn
                    )
                    // Overlay Layer
                    if showGuide {
                        BlackOverlayWithHole(
                            tutorialSteps: tutorialSteps,
                            onTutorialComplete: {
                                showGuide = false
                            }
                        )
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height
                        )
                        .position(
                            x: UIScreen.main.bounds.width / 2,
                            y: UIScreen.main.bounds.height / 2
                        )
                        .ignoresSafeArea()  // Ensure overlay covers entire screen without affecting other views
                    }
                }
                .background(.gray)
            }
        }
        .statusBar(hidden: true)
        .onChange(of: scenePhase) { newPhase in
            handleScenePhaseChange(newPhase)
        }
    }

    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            print("App became active")
            PhotoLibraryHelper.fetchLastPhoto { image in
                if let image = image {
                    self.lastPhotos = [image]
                }
            }
        case .inactive, .background:
            print("App became inactive or went to background")
        @unknown default:
            print("Unknown scene phase")
        }
    }
}

#Preview {
    dumy(tutorialSteps: tutorialSteps)
}
