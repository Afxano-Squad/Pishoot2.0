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
                        .font(.body)
                        .foregroundColor(accleroViewModel.isAccleroZ ? Color("Secondary") : .black)
                        .padding()
                        .background(accleroViewModel.isAccleroZ ? Color("Primary") : .white)
                        .cornerRadius(10)
                        .rotationEffect(gyroViewModel.rotationAngle)
    
                        .padding(.top, 30)
                    Spacer()
                }
            } else {
                
                if accleroViewModel.isAccleroX{
                    HStack {
                        if gyroViewModel.orientationManager.currentOrientation == .landscapeLeft {
                            Spacer()
                        }

                        Text(accleroViewModel.guidanceTextX)
                            .font(.body)
                            .foregroundColor(accleroViewModel.isAccleroX ? Color("Secondary") : .black)
                            .padding()
                            .background(accleroViewModel.isAccleroX ? Color("Primary") : .white)
                            .cornerRadius(10)
                            .rotationEffect(gyroViewModel.rotationAngle)
                            
                            

                        if gyroViewModel.orientationManager.currentOrientation == .landscapeRight {
                            Spacer()
                        }
                    }
                    .padding(.horizontal, -35)
                }else{
                    VStack {
                        HStack {
                            if gyroViewModel.orientationManager.currentOrientation == .landscapeLeft {
                                Spacer()
                            }

                            Text(accleroViewModel.guidanceTextX)
                                .font(.body)
                                .foregroundColor(accleroViewModel.isAccleroX ? Color("Secondary") : .black)
                                .padding()
                                .background(accleroViewModel.isAccleroX ? Color("Primary") : .white)
                                .cornerRadius(10)
                                .rotationEffect(gyroViewModel.rotationAngle)
                                

                            if gyroViewModel.orientationManager.currentOrientation == .landscapeRight {
                                Spacer()
                            }
                        }
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
