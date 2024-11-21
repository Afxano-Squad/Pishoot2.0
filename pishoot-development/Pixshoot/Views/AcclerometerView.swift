//
//  AcclerometerView.swift
//  Pixshoot
//
//  Created by Yuriko AIshinselo on 21/11/24.
//

import SwiftUI

struct AcclerometerView: View {
    @ObservedObject var accleroViewModel: AccelerometerViewModel
    let numberOfBars = 15
    @State private var accelerationText: String = "Y-Acceleration: 0.0"
    @Binding var isLocked: Bool
    
    var body: some View {
        VStack {
            // Z-Axis roll view
            ZStack {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        ForEach(0..<numberOfBars, id: \.self) { index in
                            Rectangle()
                                .fill(
                                    index == accleroViewModel.calculateDynamicIndexZ() ?
                                    Color.yellow.opacity(0.7) : Color.white.opacity(0.3)
                                )
                                .frame(width: calculateWidth(for: index), height: 10)
                        }
                    }
                }
                
                // Highlight center bar
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Rectangle()
                            .fill(accleroViewModel.calculateDynamicIndexZ() == numberOfBars / 2 ? Color.yellow : Color.white)
                            .frame(width: 60, height: 10)
                    }
                }
            }
        }
        .onAppear {
            accleroViewModel.start()
        }
        .onDisappear {
            accleroViewModel.stop()
        }
    }
    
    // For Z-axis dynamic bar width
    func calculateWidth(for index: Int) -> CGFloat {
        let dynamicIndex = accleroViewModel.calculateDynamicIndexZ()
        if index == dynamicIndex {
            return 60
        } else if abs(index - dynamicIndex) == 1 {
            return 40
        } else {
            return 20
        }
    }
    
    // For X-axis dynamic bar height (optional)
    func calculateHeight(for index: Int) -> CGFloat {
        let dynamicIndex = accleroViewModel.calculateDynamicIndexX()
        if index == dynamicIndex {
            return 60
        } else if abs(index - dynamicIndex) == 1 {
            return 40
        } else {
            return 20
        }
    }
}
