//
//  TutorialModel.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 04/11/24.
//

import SwiftUI

// Model for each tutorial step's content, including layout specifications
struct TutorialStep {
    let overlayWidth: CGFloat
    let overlayHeight: CGFloat
    let overlayPosition: CGPoint
    let image: String
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    let text: String
}
