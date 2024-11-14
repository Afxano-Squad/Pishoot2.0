import Foundation
import WatchConnectivity

#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()
    @Published var watchScreenSize: Dictionary<String,Float> = ["width":198.0, "height":242.0]
    @Published var iPhoneScreenSize: CGSize = CGSize(width: 393.0, height: 852.0)
    @Published var session: WCSession?
    @Published var position: CGPoint = CGPoint(x: 99, y: 90)
    @Published var isWatchSizeSet : Bool = false
    @Published var isCapturePhoto = false
    @Published var isPhoneInactive = false
#if os(iOS)
    @Published var previewImage: UIImage?
    var takePictureOnWatch: (() -> Void)?
#elseif os(watchOS)
    @Published var previewImage: Data?
    @Published var isIOSAppReachable = false
    
#endif
    
    private var lastSentTime: Date = Date()
    private let minTimeBetweenUpdates: TimeInterval = 0.2
    private var currentQuality: CGFloat = 0.2
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
#if os(iOS)
    func sendPreviewToWatch(_ image: UIImage) {
        guard let session = session, session.isReachable else { return }
        
        let currentTime = Date()
        guard currentTime.timeIntervalSince(lastSentTime) >= minTimeBetweenUpdates else { return }
        
        lastSentTime = currentTime
        DispatchQueue.global(qos: .userInitiated).async {
            if let resizedImage = self.resizeImage(image, to: CGSize(width: 300, height: 200)),
               let imageData = resizedImage.jpegData(compressionQuality: self.currentQuality) {
                let message = ["previewImage": imageData]
                session.sendMessage(message, replyHandler: nil) { error in
                    print("Error sending preview to watch: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func notifyWatchOfPhotoCapture() {
        guard let session = session, session.isReachable else { return }
        
        let message = ["event": "photoCaptured"]
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending photo capture notification to watch: \(error.localizedDescription)")
        }
    }
    
    func notifyPhoneisInactive() {
        guard let session = session, session.isReachable else { return }
        
        let message = ["event": "phoneInactive"]
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending phone inactive notification to watch: \(error.localizedDescription)")
        }
    }
    
    func notifyPhoneisActive() {
        guard let session = session, session.isReachable else { return }
        
        let message = ["event": "phoneActive"]
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending phone inactive notification to watch: \(error.localizedDescription)")
        }
    }
    
    
    private func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
#endif
    
#if os(watchOS)
    func sendTakePictureCommand() {
        guard let session = session, session.isReachable else { return }
        print("Send command to iPhone")
        let message = ["command": "takePicture"]
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending take picture command: \(error.localizedDescription)")
        }
    }
    
    func updateIOSAppReachability() {
        isIOSAppReachable = session?.isReachable ?? false
    }
#endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
#if os(watchOS)
            updateIOSAppReachability()
#endif
        }
    }
    
    func send(message: [String: Any]) {
        session?.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async { [self] in
            if let event = message["event"] as? String, event == "phoneInactive" {
                self.isPhoneInactive = true
                print("Received notification: Phone is inactive")
            }
            
            if let event = message["event"] as? String, event == "phoneActive" {
                self.isPhoneInactive = false
                print("Received notification: Phone is inactive")
            }
            
            if let imageData = message["previewImage"] as? Data {
#if os(iOS)
                self.previewImage = UIImage(data: imageData)
#elseif os(watchOS)
                self.previewImage = imageData
#endif
            }
            
#if os(iOS)
            if let command = message["command"] as? String, command == "takePicture" {
                self.takePictureOnWatch?()
            }
#endif
            if let x = message["x"] as? CGFloat, let y = message["y"] as? CGFloat, let isWatchSizeSet = message["isWatchSizeSet"] as? Bool {
                self.position = CGPoint(x: x, y: y)
                if(!isWatchSizeSet){
                    self.send(message: ["watchSize": self.watchScreenSize])
                }
            }
            
            if let event = message["event"] as? String, event == "photoCaptured" {
                self.isCapturePhoto = true
                print("My is capture photo : \(self.isCapturePhoto)")
            }
            
            if let watchSize = message["watchSize"] as? Dictionary<String,Float> {
                self.isWatchSizeSet = true
                self.watchScreenSize = watchSize
            }
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
#if os(watchOS)
            self.updateIOSAppReachability()
#endif
        }
    }
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated")
        WCSession.default.activate()
    }
#endif
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            print("Received application context: \(applicationContext)")
            
        }
    }
    func getWatchPosition(_ position: CGPoint) -> Dictionary<String, Float> {
        let widthScalingFactor: Float = Float(self.watchScreenSize["width"] ?? 1) / Float(iPhoneScreenSize.width)
        let heightScalingFactor: Float = Float(self.watchScreenSize["height"] ?? 1) / Float(iPhoneScreenSize.height)
        let scaledX: Float = Float(position.x) * widthScalingFactor
        let scaledY: Float = Float(position.y) * heightScalingFactor
        return ["x": scaledX, "y": scaledY]
    }
}
