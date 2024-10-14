import SwiftUI

struct WatchContentView: View {
    @ObservedObject var connectivityManager = WatchConnectivityManager.shared
    @Environment(\.scenePhase) private var scenePhase
    @State private var isActive = true
    @State private var isMarkerOn = true
    
    var body: some View {
        VStack {
            //            Text("isIosAppReachable \(connectivityManager.isIOSAppReachable)")
            //            Text("is Active \(isActive)")
            //
            
            ZStack {
                if isActive {
                    if connectivityManager.isIOSAppReachable {
                        if let imageData = connectivityManager.previewImage,
                           let uiImage = UIImage(data: imageData) {
                            let screenSize = WKInterfaceDevice.current().screenBounds.size
                            ZStack {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenSize.height, height: screenSize.width)
                                    .clipped()
                                    .rotationEffect(Angle(degrees: 90))
                                    .position(x: screenSize.width / 2, y: screenSize.height / 2)
                                if(isMarkerOn){
                                    Image(systemName: "target")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .position(connectivityManager.position)
                                }
                            }
                            .onAppear{
                                let watchSize = ["width": Float(screenSize.width), "height": Float(screenSize.height)]
                                connectivityManager.send(message: ["watchSize": watchSize])
                                connectivityManager.watchScreenSize = watchSize
                            }
                            VStack {
                                Spacer()
                                Button(action: {
                                    connectivityManager.sendTakePictureCommand()
                                }) {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray, lineWidth: 1)
                                                .frame(width: 30, height: 30)
                                        )
                                }.buttonStyle(PlainButtonStyle())
                                    .padding()
                            }
                            
                            VStack {
                                Spacer()
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        isMarkerOn.toggle()
                                    }) {
                                        Image(systemName: "target")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(isMarkerOn ? Color("pishootYellow") : .white)
                                    }.buttonStyle(PlainButtonStyle())
                                        .padding()
                                }
                            }
                        } else {
                            Text("Waiting for preview...")
                        }
                        
                    } else {
                        Text("iOS app not open")
                    }
                } else if !isActive && connectivityManager.isIOSAppReachable{
                    Color.black.edgesIgnoringSafeArea(.all)
                    Text("Inactive")
                        .foregroundColor(.white)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                isActive = true
                connectivityManager.updateIOSAppReachability()
            case .inactive, .background:
                isActive = false
            @unknown default:
                break
            }
        }
    }
}
