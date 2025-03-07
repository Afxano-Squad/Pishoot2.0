import AVFoundation
import Photos
import UIKit
import Combine

protocol CameraDelegate {
    func didCaptureComplete(image: UIImage?) -> Void
}
class CameraManager: NSObject, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    var session: AVCaptureMultiCamSession?
    private var wideAngleOutput: AVCapturePhotoOutput?
    private var ultraWideOutput: AVCapturePhotoOutput?
    
    private var wideAngleCamera: AVCaptureDevice?
    private var ultraWideCamera: AVCaptureDevice?
    
    private var captureOrientation: UIDeviceOrientation = .portrait
    private let orientationManager = DeviceOrientationManager.shared
    
    private var videoDataOutput: AVCaptureVideoDataOutput?
    @Published var selectedZoomLevel: CGFloat = 1.0
    @Published var isFlashOn: Bool = false
    @Published var isCapturingPhoto: Bool = false
    @Published var isBlackScreenVisible: Bool = false
    @Published var isMultiRatio: Bool = false
    
    private var capturedImages: [UIImage] = []
    private var completion: (([UIImage]) -> Void)?
    
    static let shared = CameraManager()
    var delegate: CameraDelegate?
    
    private override init() {
        super.init()
        setupSession()
    }
    
    // MARK: - Setup Camera Session
    private func setupSession() {
        guard AVCaptureMultiCamSession.isMultiCamSupported else {
            print("Multi-cam not supported on this device")
            return
        }
        
        session = AVCaptureMultiCamSession()
        
        guard let session = session else {
            print("Failed to initialize session")
            return
        }
        
        session.beginConfiguration()
        
        // Setup wide-angle and ultra-wide cameras
        setupCamera(.builtInWideAngleCamera, to: session)
        setupCamera(.builtInUltraWideCamera, to: session)
        
        session.commitConfiguration()
        
        print("Camera session configured successfully")
    }
    
    private func setupCamera(_ deviceType: AVCaptureDevice.DeviceType, to session: AVCaptureMultiCamSession) {
        guard let device = AVCaptureDevice.default(deviceType, for: .video, position: .back) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInputWithNoConnections(input)
            }
            
            let output = AVCapturePhotoOutput()
            if session.canAddOutput(output) {
                session.addOutputWithNoConnections(output)
            }
            
            let connection = AVCaptureConnection(inputPorts: input.ports, output: output)
            if session.canAddConnection(connection) {
                session.addConnection(connection)
            }
            
            if device.deviceType == .builtInWideAngleCamera {
                wideAngleOutput = output
                wideAngleCamera = device
            } else if device.deviceType == .builtInUltraWideCamera {
                ultraWideOutput = output
                ultraWideCamera = device
            }
        } catch {
            print("Error setting up camera: \(error)")
        }
    }
    
    private func setupVideoDataOutput() {
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if session?.canAddOutput(videoDataOutput) == true {
            session?.addOutput(videoDataOutput)
        }
        self.videoDataOutput = videoDataOutput
    }
    
    
    func startSession() {
        guard let session = session else{
            print("Session is not initialized")
            return
        }
        
        if !session.isRunning {
            session.startRunning()
            print("Camera session started")
        } else {
            print("Session already running")
        }
    }
    
    
    func stopSession() {
        guard let session = session else {
            print("Session is not initialized")
            return
        }
        
        if session.isRunning {
            session.stopRunning()
            print("Camera session stopped")
        }
    }
    
    
    func toggleFlash() {
        isFlashOn.toggle()
    }
    /// CAPTURE logic yang kasi 3 gambar
    func capturePhotos(completion: @escaping ([UIImage]) -> Void) {
        guard let session = session else {
            print("Camera session is not initialized")
            return
        }
        if session == nil {
            print ("Session is nil, reinitializing")
            setupSession()
        }
        
        if !session.isRunning {
            print("Camera session is not running. Starting it now.")
            startSession()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.capturePhotos(completion: completion)
            }
            return
        }
        guard session.isRunning else {
            print("ALREADY CAPTURING PHOTO")
            startSession()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.capturePhotos(completion: completion) // Retry after session starts
            }
            return
        }
        guard !isCapturingPhoto else {
            print("Already capturing photo")
            return
        }
        
        isCapturingPhoto = true
        capturedImages.removeAll()
        self.completion = completion
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = isFlashOn ? .on : .off
        
        captureOrientation = orientationManager.currentOrientation
        
        guard let wideAngleOutput = wideAngleOutput else {
            print("Wide Angle Camera output is not set")
            return
        }
        
        print("Capturing photo from wide-angle camera...")
        wideAngleOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func captureZoomedPhotos() {
        guard let wideAngleCamera = wideAngleCamera else { return }
        do {
            try wideAngleCamera.lockForConfiguration()
            wideAngleCamera.videoZoomFactor = 2.0
            
            // Siapkan pengaturan foto dengan HEIF codec jika tersedia
            let zoomedPhotoSettings: AVCapturePhotoSettings
            if wideAngleOutput?.availablePhotoCodecTypes.contains(.hevc) == true {
                zoomedPhotoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            } else {
                zoomedPhotoSettings = AVCapturePhotoSettings()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.wideAngleOutput?.capturePhoto(with: zoomedPhotoSettings, delegate: self)
            }
            
            wideAngleCamera.unlockForConfiguration()
        } catch {
            print("Error setting zoom factor: \(error)")
        }
    }
    
    
    private func saveImagesToPhotoLibrary(images: [UIImage]) {
        print ("image saved to photo library")
        PhotoLibraryHelper.saveImagesToAlbum(images: images)
    }
    
    func setZoomLevel(zoomLevel: CGFloat) {
        selectedZoomLevel = zoomLevel
        if zoomLevel == 0.5 {
            switchToUltraWideCamera()
        } else {
            switchToWideAngleCamera(zoomLevel: zoomLevel)
        }
    }
    
    private func switchToUltraWideCamera() {
        guard let session = session, let ultraWideCamera = ultraWideCamera else { return }
        session.beginConfiguration()
        for input in session.inputs {
            session.removeInput(input)
        }
        do {
            let input = try AVCaptureDeviceInput(device: ultraWideCamera)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            session.commitConfiguration()
        } catch {
            print("Error switching to ultra-wide camera: \(error)")
        }
    }
    
    private func switchToWideAngleCamera(zoomLevel: CGFloat) {
        guard let session = session, let wideAngleCamera = wideAngleCamera else { return }
        session.beginConfiguration()
        for input in session.inputs {
            session.removeInput(input)
        }
        do {
            let input = try AVCaptureDeviceInput(device: wideAngleCamera)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            wideAngleCamera.videoZoomFactor = zoomLevel
            session.commitConfiguration()
        } catch {
            print("Error switching to wide-angle camera: \(error)")
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Error capturing photo: \(error)")
                self.isBlackScreenVisible = false
                if self.isFlashOn {
                    self.turnTorch(on: false)
                }
                return
            }
            
            guard let imageData = photo.fileDataRepresentation(),
                  let image = UIImage(data: imageData) else { return }
            
            
            DispatchQueue.main.async {
                print("Photo captured successfully")
                
                self.delegate?.didCaptureComplete(image: self.capturedImages.last)
                
            }
            
            PhotoLibraryHelper.requestPhotoLibraryPermission { [weak self] authorized in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if authorized {
                        self.capturedImages.append(image)
                        
                        if self.capturedImages.count == 2 {
                            self.captureZoomedPhotos()
                        }
                        
                        if self.capturedImages.count == 3 {
                            self.backToNormalLens()
                            self.processAndSaveImages()
                        }
                    } else {
                        print("Photo library access not authorized")
                        self.isBlackScreenVisible = false
                        if self.isFlashOn {
                            self.turnTorch(on: false)
                        }
                    }
                }
            }
        }
    }
    
    private func processAndSaveImages() {
        if self.isMultiRatio {
            let rotatedImages = self.capturedImages.map { self.rotateImage($0, orientation: self.captureOrientation) }
            self.saveImagesToPhotoLibrary(images: rotatedImages)
            self.processImagesInBackground(self.capturedImages) { processedImages in
                let rotatedImages = processedImages.map { self.rotateImage($0, orientation: self.captureOrientation) }
                self.saveImagesToPhotoLibrary(images: rotatedImages)
                self.completion?(rotatedImages)
                self.completion = nil
                self.isCapturingPhoto = false
            }
        } else {
            let rotatedImages = self.capturedImages.map { self.rotateImage($0, orientation: self.captureOrientation) }
            self.saveImagesToPhotoLibrary(images: rotatedImages)
            self.completion?(rotatedImages)
            self.completion = nil
            self.isCapturingPhoto = false
        }
    }
    
    
    private func processImagesInBackground(_ images: [UIImage], completion: @escaping ([UIImage]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var processedImages: [UIImage] = []
            
            for image in images {
                processedImages.append(contentsOf: self.generateMultiRatios(for: image))
            }
            
            DispatchQueue.main.async {
                completion(processedImages)
            }
        }
    }
    
    private func generateMultiRatios(for image: UIImage) -> [UIImage] {
        let aspectRatios: [CGFloat] = [3.0 / 4.0, 1.0]
        var croppedImages: [UIImage] = []
        
        for aspectRatio in aspectRatios {
            if let croppedImage = cropImage(image, toAspectRatio: aspectRatio) {
                croppedImages.append(croppedImage)
            }
        }
        
        return croppedImages
    }
    
    private func cropImage(_ image: UIImage, toAspectRatio aspectRatio: CGFloat) -> UIImage? {
        let fixedImage = image.fixOrientation()
        
        let originalSize = fixedImage.size
        
        var cropRect: CGRect
        let newHeight: CGFloat
        
        if aspectRatio == 3.0 / 4.0 {
            newHeight = originalSize.width * (4.0 / 3.0)
        } else if aspectRatio == 1.0 {
            newHeight = originalSize.width
        } else {
            return nil
        }
        
        if newHeight > originalSize.height {
            return fixedImage
        }
        
        let yOffset = (originalSize.height - newHeight) / 2
        cropRect = CGRect(x: 0, y: yOffset, width: originalSize.width, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: cropRect.width, height: cropRect.height), false, fixedImage.scale)
        fixedImage.draw(at: CGPoint(x: -cropRect.origin.x, y: -cropRect.origin.y))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return croppedImage
    }
    
    
    
    func backToNormalLens() {
        if selectedZoomLevel == 0.5 {
            switchToUltraWideCamera()
        } else {
            switchToWideAngleCamera(zoomLevel: selectedZoomLevel)
        }
        
        self.isBlackScreenVisible = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.isFlashOn {
                self.turnTorch(on: false)
            }
        }
    }
    func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    private func sendPreviewToWatch(_ image: UIImage) {
        WatchConnectivityManager.shared.sendPreviewToWatch(image)
    }
    
    func turnTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            if on {
                try device.setTorchModeOn(level: 1.0)
            }
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used: \(error)")
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        let image = UIImage(cgImage: cgImage)
//        sendPreviewToWatch(image)
    }
    
    private func rotateImage(_ image: UIImage, orientation: UIDeviceOrientation) -> UIImage {
        var rotationAngle: CGFloat = 0
        var newSize: CGSize = image.size
        
        switch orientation {
        case .landscapeLeft:
            rotationAngle = -CGFloat.pi / 2
            newSize = CGSize(width: image.size.height, height: image.size.width)
        case .landscapeRight:
            rotationAngle = CGFloat.pi / 2
            newSize = CGSize(width: image.size.height, height: image.size.width)
        case .portraitUpsideDown:
            rotationAngle = CGFloat.pi
        default:
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        if orientation == .portraitUpsideDown {
            context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
            context.rotate(by: rotationAngle)
            context.translateBy(x: -newSize.width / 2, y: -newSize.height / 2)
            image.draw(in: CGRect(origin: .zero, size: newSize))
        } else {
            context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
            context.rotate(by: rotationAngle)
            image.draw(in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
        }
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? self
    }
}
