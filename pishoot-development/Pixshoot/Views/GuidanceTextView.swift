import SwiftUI

struct GuidanceTextView: View {
    @ObservedObject var gyroViewModel: GyroViewModel
    @ObservedObject var accleroViewModel: AccelerometerViewModel
    var GuidanceText: String = ""
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
                        .frame(maxWidth: .infinity) // Center horizontally
                                        .frame(maxHeight: .infinity, alignment: .top) // Align to the top
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
                            .frame(maxHeight: .infinity) // Center horizontally
                            .rotationEffect(gyroViewModel.rotationAngle)
                            
                            

                        if gyroViewModel.orientationManager.currentOrientation == .landscapeRight {
                            Spacer()
                        }
                    }
                    .padding(.horizontal, -30)
                    .padding(.vertical, 20)
                }else{
                    VStack {
                        HStack {
                            if gyroViewModel.orientationManager.currentOrientation ==
                                .landscapeLeft {
                                Spacer()
                            }

                            
                                Text(accleroViewModel.guidanceTextX)
                                    .font(.body)
                                    .foregroundColor(accleroViewModel.isAccleroX ? Color("Secondary") : .black)
                                    .padding()
                                    .background(accleroViewModel.isAccleroX ? Color("Primary") : .white)
                                    .cornerRadius(10)
                                    .frame(maxHeight: .infinity) // Center horizontally
                                    .rotationEffect(gyroViewModel.rotationAngle)

                            if gyroViewModel.orientationManager.currentOrientation == .landscapeRight {
                                Spacer()
                            }
                        }
                        .padding(.vertical, -20)
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
