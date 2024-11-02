import SwiftUI
import WatchKit
import WatchConnectivity


struct WatchContentView: View {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    @StateObject private var watchViewModel = WatchViewModel()
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack {
            ZStack {
                if watchViewModel.isActive {
                    if connectivityManager.isIOSAppReachable {
                        if let imageData = connectivityManager.previewImage,
                           let uiImage = UIImage(data: imageData) {
                            let screenSize = WKInterfaceDevice.current().screenBounds.size
                            
                            ZStack {
                                // Image Display
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenSize.height, height: screenSize.width)
                                    .clipped()
                                    .rotationEffect(Angle(degrees: 90))
                                    .position(x: screenSize.width / 2, y: screenSize.height / 2)
                                
                            }
                            .onAppear {
                                // Send watch screen size to iOS app
                                let watchSize = ["width": Float(screenSize.width), "height": Float(screenSize.height)]
                                connectivityManager.send(message: ["watchSize": watchSize])
                                connectivityManager.watchScreenSize = watchSize
                                
                                // Ensure display stays active
                                watchViewModel.keepDisplayActive()
                            }
                            
                            // Take Picture Button
                            VStack {
                                Spacer()
                                Button(action: {
                                    connectivityManager.sendTakePictureCommand()
                                    // Haptic feedback has been removed
                                }) {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray, lineWidth: 1)
                                                .frame(width: 30, height: 30)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding()
                            }
                            
                        } else {
                            Text("Waiting for preview...")
                        }
                    } else {
                        Text("iOS app not open")
                    }
                } else if !watchViewModel.isActive && connectivityManager.isIOSAppReachable {
                    Color.black.edgesIgnoringSafeArea(.all)
                    Text("Inactive")
                        .foregroundColor(.white)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onChange(of: scenePhase) { newPhase in
            handleScenePhaseChange(newPhase)
        }
    }
    
    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            watchViewModel.isActive = true
            connectivityManager.updateIOSAppReachability()
            watchViewModel.keepDisplayActive()
            printCurrentState("active")
        case .inactive:
            watchViewModel.isActive = false
            watchViewModel.stopKeepingDisplayActive()
            printCurrentState("inactive")
        case .background:
            watchViewModel.isActive = false
            watchViewModel.stopKeepingDisplayActive()
            printCurrentState("background")
        @unknown default:
            break
        }
    }
    
    private func printCurrentState(_ state: String) {
        print("The app is currently in the \(state) state.")
    }
}
