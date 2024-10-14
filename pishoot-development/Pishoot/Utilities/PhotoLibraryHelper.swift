//
//  PhotoLibraryHelper.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import UIKit
import Photos

struct PhotoLibraryHelper {
    static func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }

    static func openPhotosApp() {
        if let url = URL(string: "photos-redirect://") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    static func fetchLastPhoto(completion: @escaping (UIImage?) -> Void) {
        requestPhotoLibraryPermission { authorized in
            if authorized {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.fetchLimit = 1
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

                if let asset = fetchResult.firstObject {
                    let imageManager = PHImageManager.default()
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .highQualityFormat
                    options.isSynchronous = true
                    imageManager.requestImage(for: asset, targetSize: CGSize(width: 50, height: 50), contentMode: .aspectFill, options: options) { image, _ in
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
