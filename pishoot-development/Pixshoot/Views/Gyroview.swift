import SwiftUI

struct GyroView: View {
    @StateObject private var gyroViewModel = GyroViewModel()
    @Binding var isMarkerOn: Bool
    
    var body: some View {
        ZStack {
            VStack {
                // Guidance Text Display
                Text(gyroViewModel.guidanceText)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.top, 20)
                
                Spacer()
                
                // Rotating Circle View
                ZStack {
                    // Outer Circle
                    Circle()
                        .stroke(Color.red, lineWidth: 4)
                        .frame(width: 100, height: 100)
                    
                    // Inner Circle
                    Circle()
                        .fill(gyroViewModel.isPitchSuccess ? .green : .red)
                        .frame(width: 70, height: 70)
                        .rotation3DEffect(
                            Angle(degrees: gyroViewModel.pitch * 180 / .pi),
                            axis: (x: 1, y: 0, z: 0)
                        )
                    
                   
                    Circle()
                        .stroke(Color.red, lineWidth: 3)
                        .frame(width: 25, height: 25)
                        .offset(y: -70)
                    
                    Circle()
                        .fill(gyroViewModel.isRollSuccess ? .green : .red)
                        .frame(width: 15, height: 15)
                        .offset(y: -70)
                        .rotationEffect(Angle(degrees: gyroViewModel.roll * 0.2 * 360 / .pi))
                }
                .padding()
                Spacer()
                
                // Bottom Lock Button
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
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
