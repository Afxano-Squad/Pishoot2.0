//
//  PhotoThumbnailView.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import SwiftUI

struct PhotoThumbnailView: View {
    var lastPhoto: UIImage?
    var openPhotosApp: () -> Void
    @ObservedObject var gyroViewModel: GyroViewModel

    var body: some View {
        if let lastPhoto = lastPhoto {
            Button(action: {
                openPhotosApp()
            }) {
                Image(uiImage: lastPhoto)
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Preserve aspect ratio
                    .frame(width: 57, height: 57)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
////                            .stroke(Color.white, lineWidth: 2)
//                    )
                    .clipped()
                    .rotationEffect(gyroViewModel.rotationAngle)
                    .animation(.easeInOut(duration: 0.3), value: gyroViewModel.rotationAngle)
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fill) // Preserve aspect ratio
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
////                        .stroke(Color.white, lineWidth: 2)
//                )
                .clipped()
                .rotationEffect(gyroViewModel.rotationAngle)
                .animation(.easeInOut(duration: 0.3), value: gyroViewModel.rotationAngle)
        }
    }
}


#Preview {
    PhotoThumbnailView(lastPhoto: nil, openPhotosApp: {}, gyroViewModel: GyroViewModel())
}
