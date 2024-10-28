//
//  OnBoardingDataModel.swift
//  Pishoot
//
//  Created by Nadhirul Fatah Ulhaq on 03/07/24.
//

import Foundation

struct OnBoardingDataModel {
    var imageName: String
    var title: String
    var description: String
    var progress: Float
}

extension OnBoardingDataModel {
    static var data: [OnBoardingDataModel] = [
        OnBoardingDataModel(imageName: "PositionAsYouWish", title: "Position as you wish", description: "Set custom markers before handing your phone to a stranger. These markers help you position yourself faster and perfectly.", progress: 0.40),
        OnBoardingDataModel(imageName: "TripleZoomPhotos", title: "Triple Zoom Photos", description: "Capture three photos at different zoom levels with a single click. This ensures you get a variety of shots, from wide-angle to close-up, all in one go.", progress: 0.60),
        OnBoardingDataModel(imageName: "MultiRatioPhotoScale", title: "Multi Ratio Photo Scale", description: "Capture three photos at different zoom levels and different photo ratio with a single click. This ensures you get a variety of shots.", progress: 0.80),
        OnBoardingDataModel(imageName: "SeeYourAppleWatch", title: "See Your Apple Watch", description: "Use your Apple Watch to see the markers and adjust your position quickly and easily, without needing to check your phone.", progress: 1.00)
    ]
}
