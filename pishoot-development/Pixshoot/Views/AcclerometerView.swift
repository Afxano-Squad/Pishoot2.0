//
//  AcclerometerView.swift
//  Pixshoot
//
//  Created by Yuriko AIshinselo on 21/11/24.
//

import SwiftUI

struct AcclerometerView: View {
    @ObservedObject var accleroViewModel: AccelerometerViewModel
    @ObservedObject var gyroViewModel: GyroViewModel
    let numberOfBars = 15
    @Binding var isLocked: Bool
    
    var body: some View {
        ZStack {
            // Z-Axis Roll View
            if gyroViewModel.orientationManager.currentOrientation == .portrait || gyroViewModel.orientationManager.currentOrientation == .portraitUpsideDown {
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
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            Rectangle()
                                .fill(accleroViewModel.calculateDynamicIndexZ() == numberOfBars / 2 ? Color.yellow : Color.white)
                                .frame(width: 60, height: 10)
                        }
                    }
                }
            } else {
                ZStack {
                    VStack {
                        HStack(alignment: .top) {
                            ForEach(0..<numberOfBars, id: \.self) { index in
                                Rectangle()
                                    .fill(
                                        index == accleroViewModel.calculateDynamicIndexX() ?
                                        Color.blue.opacity(0.7) : Color.white.opacity(0.3)
                                    )
                                    .frame(width: 10, height: calculateHeight(for: index))
                            }
                        }
                        Spacer()
                    }
                    
                    
                    VStack{
                        HStack {
                            Rectangle()
                                .fill(accleroViewModel.calculateDynamicIndexX() == numberOfBars / 2 ? Color.blue : Color.white)
                                .frame(width: 10, height: 60)
                        }
                        Spacer()
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
    
    // For X-axis dynamic bar height
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

#Preview{
    AcclerometerView(accleroViewModel: AccelerometerViewModel(), gyroViewModel: GyroViewModel(), isLocked: .constant(true ))
}
