//
//  TutorialContent.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 04/11/24.
//

import SwiftUI

let tutorialSteps: [TutorialStep] = [
    TutorialStep(
        overlayWidth: 200,
        overlayHeight: 150,
        overlayPositionX: -150,
        overlayPositionY: 300,
        image: "hand.point.up.left.fill",
        imageWidth: 100,
        imageHeight: 150,
        text: "Set the frame to the angle you want before requesting someone to take your picture."
    ),
    TutorialStep(
        overlayWidth: 220,
        overlayHeight: 180,
        overlayPositionX: 180,
        overlayPositionY: 320,
        image: "hand.tap.fill",
        imageWidth: 120,
        imageHeight: 160,
        text: "Ensure the camera is stable and clear."
    ),
    TutorialStep(
        overlayWidth: 250,
        overlayHeight: 170,
        overlayPositionX: 0,
        overlayPositionY: 330,
        image: "camera",
        imageWidth: 130,
        imageHeight: 170,
        text: "Press the shutter button to take a photo."
    )
]
