//
//  TutorialContent.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 04/11/24.
//

import SwiftUI

let tutorialSteps: [TutorialStep] = [
    TutorialStep(
        overlayWidth: UIScreen.main.bounds.width ,
        overlayHeight: UIScreen.main.bounds.height ,
        overlayPositionX: 0,
        overlayPositionY: 0,
        image: "hand.point.up.left.fill",
        imageWidth: 100,
        imageHeight: 150,
        text: "First, point your first shoot"
    ),
    TutorialStep(
        overlayWidth: 75,
        overlayHeight: 85,
        overlayPositionX: 140,
        overlayPositionY: 300,
        image: "hand.point.up.left.fill",
        imageWidth: 100,
        imageHeight: 150,
        text: "Lock your photo position by tap lock button"
    ),
    TutorialStep(
        overlayWidth: UIScreen.main.bounds.width,
        overlayHeight: UIScreen.main.bounds.height,
        overlayPositionX: 0,
        overlayPositionY: 0,
        image: "",
        imageWidth: 0,
        imageHeight: 0,
        text: ""
    ),
    TutorialStep(
        overlayWidth: 100,
        overlayHeight: 120,
        overlayPositionX: 0,
        overlayPositionY: 300,
        image: "camera",
        imageWidth: 130,
        imageHeight: 170,
        text: "Press the shutter button to take a photo."
    ),
    TutorialStep(
        overlayWidth: UIScreen.main.bounds.width,
        overlayHeight: UIScreen.main.bounds.height,
        overlayPositionX: 0,
        overlayPositionY: 0,
        image: "",
        imageWidth: 0,
        imageHeight: 0,
        text: ""
    )
    
]
