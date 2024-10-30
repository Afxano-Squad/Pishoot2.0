import SwiftUI

struct GyroView: View {
    @ObservedObject var gyroViewModel: GyroViewModel
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
