//
//  PhotoLibraryHelper2.swift
//  Pixshoot
//
//  Created by Farid Andika on 24/11/24.
//

import Foundation


import UIKit
import Photos

struct PhotoLibraryHelper2 {
    static let albumName = "Pixshoot"
    static var assetCollection: PHAssetCollection?

    static func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
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
                    let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                    assetCollection = collection.firstObject
                    completion()
                } else if let error = error {
                    print("Error creating album: \(error)")
                }
            }
        }
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
}
