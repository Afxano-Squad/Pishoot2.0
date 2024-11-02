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

    var body: some View {
        if let lastPhoto = lastPhoto {
            Button(action: {
                openPhotosApp()
            }) {
                Image(uiImage: lastPhoto)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .clipped()
            }
            .accessibilityLabel("Gallery")
            .accessibilityHint("Tap to view your latest photos.")
        } else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                .clipped()
                
        }
    }
}

#Preview {
    PhotoThumbnailView(lastPhoto: nil, openPhotosApp: {})
}

