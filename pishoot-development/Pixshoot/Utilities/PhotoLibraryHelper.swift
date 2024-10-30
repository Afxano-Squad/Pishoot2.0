//
//  PhotoLibraryHelper.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import UIKit
import Photos

struct PhotoLibraryHelper {
    static let albumName = "Pixshoot"
    static var assetCollection: PHAssetCollection?
    static var albumPlaceholder: PHObjectPlaceholder?
    
    
    
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
    
    static func createAlbumIfNeeded(completion: @escaping () -> Void) {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            if let existingAlbum = collection.firstObject {
                assetCollection = existingAlbum
                completion()
            } else {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                }) { success, error in
                    if success {
                        // Fetch the newly created album
                        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                        assetCollection = collection.firstObject
                        completion()
                    } else if let error = error {
                        print("Error creating album: \(error)")
                    }
                }
            }
        }
    
    static func fetchCreatedAlbum() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        assetCollection = collection.firstObject
    }
    
    static func saveImagesToAlbum(images: [UIImage]) {
            createAlbumIfNeeded {
                guard let album = assetCollection else {
                    print("Album not found or created.")
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    for image in images {
                        let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                        if let placeholder = assetChangeRequest.placeholderForCreatedAsset {
                            let addAssetRequest = PHAssetCollectionChangeRequest(for: album)
                            addAssetRequest?.addAssets([placeholder] as NSArray)
                        }
                    }
                }, completionHandler: { success, error in
                    if success {
                        print("Images saved successfully to album: \(albumName)")
                    } else if let error = error {
                        print("Error saving images to album: \(error)")
                    }
                })
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
