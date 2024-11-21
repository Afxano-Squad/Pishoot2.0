import SwiftUI

struct GuidanceTextView: View {
    @ObservedObject var gyroViewModel: GyroViewModel
    @ObservedObject var accleroViewModel: AccelerometerViewModel

    var body: some View {
        ZStack {
            if gyroViewModel.orientationManager.currentOrientation == .portrait || gyroViewModel.orientationManager.currentOrientation == .portraitUpsideDown {
                // Portrait orientation: text appears at the top center
                VStack {
                    Text(accleroViewModel.guidanceText)
                        .foregroundColor(accleroViewModel.isAcclero ? Color("Secondary") : .black)
                        .padding()
                        .background(accleroViewModel.isAcclero ? Color("Primary") : .white)
                        .cornerRadius(10)
                        .rotationEffect(gyroViewModel.rotationAngle)
                        .padding(.top, 30)
                }
            } else {
                // Landscape orientation: text appears at the center-left or center-right
                HStack {
                    if gyroViewModel.orientationManager.currentOrientation == .landscapeLeft {
                        Spacer() // Push text to the center-right
                    }

                    Text(accleroViewModel.guidanceText) // Use the guidanceText from AccelerometerViewModel
                        .foregroundColor(accleroViewModel.isAcclero ? Color("Secondary") : .black)
                        .padding()
                        .background(accleroViewModel.isAcclero ? Color("Primary") : .white)
                        .cornerRadius(10)
                        .rotationEffect(gyroViewModel.rotationAngle)

                    if gyroViewModel.orientationManager.currentOrientation == .landscapeRight {
                        Spacer() // Push text to the center-left
                    }
                }
                .padding(.top, -30)
            }
        } .padding()
        .onAppear {
            gyroViewModel.startGyros()
            accleroViewModel.start() // Start accelerometer updates
        }
        .onDisappear {
            gyroViewModel.stopGyros()
            accleroViewModel.stop() // Stop accelerometer updates
        }
    }
}

//#Preview {
//    GuidanceTextView(gyroViewModel: GyroViewModel(), accleroViewModel: AccelerometerViewModel())
//}
