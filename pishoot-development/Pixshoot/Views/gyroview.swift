//
//  gyroview.swift
//  Pishoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 28/10/24.
//

import SwiftUI


struct GyroView: View {
    @StateObject private var gyroViewModel = GyroViewModel()
    @Binding var isMarkerOn: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Text(gyroViewModel.guidanceText)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.top, 20)
                
                Spacer()
                ZStack {
                    // Pitch rectangle (red)
                    Rectangle()
                        .stroke(lineWidth: 5)
                        .foregroundColor(.red)
                        .frame(width: 40, height: 40)
                        .rotation3DEffect(
                            .degrees(gyroViewModel.pitch * 180 / .pi),
                            axis: (x: 1, y: 0, z: 0)
                        )

                    // Yaw rectangle (blue)
                    Rectangle()
                        .stroke(lineWidth: 5)
                        .foregroundColor(.blue)
                        .frame(width: 70, height: 70)
                        .rotation3DEffect(
                            .degrees(gyroViewModel.yaw * 180 / .pi),
                            axis: (x: 0, y: 1, z: 0)
                        )

//                    // Roll rectangle (green)
//                    Rectangle()
//                        .stroke(lineWidth: 5)
//                        .foregroundColor(.green)
//                        .frame(width: 45, height: 45)
//                        .rotation3DEffect(
//                            .degrees(gyroViewModel.roll * 180 / .pi),
//                            axis: (x: 0, y: 0, z: 1)
//                        )
                }
                .padding()
                Spacer()
                HStack {
                    
                    

                    Spacer()

                    // Lock Button
                    Button(action: {
                        // Place AR anchor and lock gyro coordinates
                        gyroViewModel.lockGyroCoordinates()
                        gyroViewModel.resetGyroValues()
                    }) {
                        Image(systemName: "lock.square.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 30)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            gyroViewModel.startGyros()
        }
        .onDisappear {
            gyroViewModel.stopGyros()
        }
        
    }
}

#Preview {
    GyroView(isMarkerOn: .constant(false))
}
