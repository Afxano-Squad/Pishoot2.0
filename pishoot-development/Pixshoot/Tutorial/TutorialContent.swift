//
//  TutorialContent.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 04/11/24.
//

import SwiftUI

let tutorialSteps: [TutorialStep] = [
        TutorialStep(
            overlayWidth: 200, overlayHeight: 150, overlayPosition: CGPoint(x: 150, y: 300),
            image: "hand.point.up.left.fill", imageWidth: 100, imageHeight: 150,
            text: "Sebelum minta tolong orang lain, cari angle yang kamu inginkan."
        ),
        TutorialStep(
            overlayWidth: 220, overlayHeight: 180, overlayPosition: CGPoint(x: 180, y: 320),
            image: "hand.tap.fill", imageWidth: 120, imageHeight: 160,
            text: "Pastikan kamera stabil dan jelas."
        ),
        TutorialStep(
            overlayWidth: 250, overlayHeight: 170, overlayPosition: CGPoint(x: 200, y: 330),
            image: "camera", imageWidth: 130, imageHeight: 170,
            text: "Tekan tombol shutter untuk memotret."
        )
    ]
