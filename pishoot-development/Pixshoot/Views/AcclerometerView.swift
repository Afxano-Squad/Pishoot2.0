//
//  AcclerometerView.swift
//  Pixshoot
//
//  Created by Yuriko AIshinselo on 21/11/24.
//

import SwiftUI

struct AcclerometerView: View {
    @ObservedObject var acleroViewModel: AccelerometerViewModel
    let numberOfBars = 15
    @State private var accelerationText: String = "Y-Acceleration: 0.0"
    @Binding var isLocked: Bool

    var body: some View {
        VStack {
            // Roll View for Acceleration Z
            ZStack {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        ForEach(0..<numberOfBars, id: \.self) { index in
                            Rectangle()
                                .fill(
                                    index == calculateDynamicIndexZ() ?
                                    Color.yellow.opacity(0.7) : Color.white.opacity(0.3)
                                )
                                .frame(width: calculateWidth(for: index), height: 10)
                        }
                    }
                }

                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Rectangle()
                            .fill(calculateDynamicIndexZ() == numberOfBars / 2 ? Color.yellow : Color.white)
                            .frame(width: 60, height: 10)
                    }
                }
            }
            .padding()
            .overlay(Text("Roll View (Z)").font(.headline).foregroundColor(.white), alignment: .top)

            // Roll View for Acceleration X
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        ForEach(0..<numberOfBars, id: \.self) { index in
                            Rectangle()
                                .fill(
                                    index == calculateDynamicIndexX() ?
                                    Color.blue.opacity(0.7) : Color.white.opacity(0.3)
                                )
                                .frame(width: 10, height: calculateHeight(for: index))
                        }
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Rectangle()
                            .fill(calculateDynamicIndexX() == numberOfBars / 2 ? Color.blue : Color.white)
                            .frame(width: 10, height: 60)
                    }
                }
            }
            .padding()
            .overlay(Text("Roll View (X)").font(.headline).foregroundColor(.white), alignment: .top)
        }
        .onAppear {
            acleroViewModel.start()
        }
        .onDisappear {
            acleroViewModel.stop()
        }
    }

    // For Z-axis roll view
    func calculateWidth(for index: Int) -> CGFloat {
        if index == calculateDynamicIndexZ() {
            return 60
        } else if abs(index - calculateDynamicIndexZ()) == 1 {
            return 40
        } else {
            return 20
        }
    }

    func calculateDynamicIndexZ() -> Int {
        let midIndex = numberOfBars / 2
        let offsetZ = acleroViewModel.lockedBaselineZ ?? 0.0
        let adjustedZ = acleroViewModel.accelerationZ - offsetZ // Adjust by baseline
        let scaledZ = Int(adjustedZ * 6.5) // Scale the acceleration for visual representation
        let adjustedIndex = midIndex + scaledZ

        return max(0, min(numberOfBars - 1, adjustedIndex)) // Keep within bounds
    }

    // For X-axis roll view
    func calculateHeight(for index: Int) -> CGFloat {
        if index == calculateDynamicIndexX() {
            return 60
        } else if abs(index - calculateDynamicIndexX()) == 1 {
            return 40
        } else {
            return 20
        }
    }

    func calculateDynamicIndexX() -> Int {
        let midIndex = numberOfBars / 2
        let offsetX = acleroViewModel.lockedBaselineX ?? 0.0
        let adjustedX = acleroViewModel.accelerationX - offsetX // Adjust by baseline
        let scaledX = Int(adjustedX * 6.5) // Scale the acceleration for visual representation
        let adjustedIndex = midIndex + scaledX

        return max(0, min(numberOfBars - 1, adjustedIndex)) // Keep within bounds
    }
}
