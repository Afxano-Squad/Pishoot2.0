import SwiftUI

struct GuidanceTextView: View {
    @ObservedObject var gyroViewModel: GyroViewModel
    @ObservedObject var accleroViewModel: AccelerometerViewModel
    var body: some View {
        
        ZStack {
            if gyroViewModel.orientationManager.currentOrientation == .portrait || gyroViewModel.orientationManager.currentOrientation == .portraitUpsideDown {
                // Portrait orientation: text appears at the top center
                VStack {
                    Text(accleroViewModel.guidanceTextZ)
                        .foregroundColor(accleroViewModel.isAccleroZ ? Color("Secondary") : .black)
                        .padding()
                        .background(accleroViewModel.isAccleroZ ? Color("Primary") : .white)
                        .cornerRadius(10)
                        .rotationEffect(gyroViewModel.rotationAngle)
                        .padding(.top, 30)
                    Spacer()
                }
            } else {
                // Landscape orientation: text appears at the center-left or center-right
                HStack {
                    if gyroViewModel.orientationManager.currentOrientation == .landscapeLeft {
                        Spacer() // Push text to the center-right
                    }
                    
                    Text(accleroViewModel.guidanceTextX)
                        .foregroundColor(accleroViewModel.isAccleroX ? Color("Secondary") : .black)
                        .padding()
                        .background(accleroViewModel.isAccleroX ? Color("Primary") : .white)
                        .cornerRadius(10)
                        .rotationEffect(gyroViewModel.rotationAngle)
                    
                    if gyroViewModel.orientationManager.currentOrientation == .landscapeRight {
                        Spacer() // Push text to the center-left
                    }
                }
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
    GuidanceTextView(gyroViewModel: GyroViewModel(), accleroViewModel: AccelerometerViewModel())
}
