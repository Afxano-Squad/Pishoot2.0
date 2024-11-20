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
    @State var arView = ARView(frame: .zero)
    @StateObject private var frameViewModel: FrameViewModel
    @State private var isCapturingPhoto = false

    init() {
        let arViewInstance = ARView(frame: .zero)
        _arView = State(initialValue: arViewInstance)
        _frameViewModel = StateObject(wrappedValue: FrameViewModel(arView: arViewInstance))
    }

    var body: some View {
        ZStack {
            ARViewContainer(arView: $arView)
                .edgesIgnoringSafeArea(.all)
            
            if frameViewModel.model.anchor != nil {
                GreenOverlay(overlayColor: frameViewModel.model.overlayColor)
                    .transition(.scale)
                    .animation(.easeInOut, value: frameViewModel.model.anchor)
            }

            VStack {
                Spacer()

                if !frameViewModel.model.alignmentStatus.isEmpty {
                    Text(frameViewModel.model.alignmentStatus)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
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
