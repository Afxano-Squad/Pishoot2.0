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
    
}

extension OnBoardingDataModel {
    static var data: [OnBoardingDataModel] = [
        OnBoardingDataModel(imageName: "OnBoarding1", title: "3-in-1 Photos with a Single Click", description: "Capture three images with one click, each at a different zoom level. This way, you’ll get a variety of shots in a single capture, from close-ups to wide angles."),
        OnBoardingDataModel(imageName: "OnBoarding2", title: "Secure Your Perfect Angle", description: "Before giving over your phone, mark framing position you want to ensure you receive the exact frame you want."),
        OnBoardingDataModel(imageName: "OnBoarding3", title: "Feel the Perfect Shot", description: "Your Apple Watch will give you haptic feedback when the picture is taken. Now you'll know when to smile confidently.")
    ]
}
