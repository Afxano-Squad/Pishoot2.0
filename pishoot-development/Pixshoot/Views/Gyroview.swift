import SwiftUI

struct GyroView: View {
    @ObservedObject var gyroViewModel: GyroViewModel
    @Binding var isMarkerOn: Bool

    var body: some View {
        ZStack {
                   if gyroViewModel.orientationManager.currentOrientation == .portrait || gyroViewModel.orientationManager.currentOrientation == .portraitUpsideDown {
                       // Portrait orientation: text appears at the top center
                       VStack {
                           Text(gyroViewModel.guidanceText)
                               .foregroundColor(.white)
                               .padding()
                               .background(Color.black.opacity(0.7))
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
                           
                           Text(gyroViewModel.guidanceText)
                               .foregroundColor(.white)
                               .padding()
                               .background(Color.black.opacity(0.7))
                               .cornerRadius(10)
                               .rotationEffect(gyroViewModel.rotationAngle)
                           
                           if gyroViewModel.orientationManager.currentOrientation == .landscapeRight {
                               Spacer() // Push text to the center-left
                           }
                       }.padding(.top,-30)
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
    GyroView(gyroViewModel: GyroViewModel(), isMarkerOn: .constant(false))
}
