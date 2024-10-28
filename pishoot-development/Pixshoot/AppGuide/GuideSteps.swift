//
//  GuideSteps.swift
//  Pishoot
//
//  Created by Nadhirul Fatah Ulhaq on 05/07/24.
//

import SwiftUI

let guideSteps: [GuideStep] = [
    GuideStep(id: "Top Control",
              message: "You can access more to set up by showing what's in the top control.",
              highlightFrame: CGRect.zero,
              arrowPosition: .top,
              popUpX: 0.5,
              popUpY: -0.38,
              arrowX: 0.5,
              arrowY: 0.025),
    
    GuideStep(id: "Position Marker",
              message: "You can add a marker at the position you want on the camera.",
              highlightFrame: CGRect.zero,
              arrowPosition: .bottom,
              popUpX: 0.5,
              popUpY: 0.65,
              arrowX: 0.5,
              arrowY: 0.22),
    
    GuideStep(id: "Set Your Position Marker",
              message: "Drag and move your position marker based on your preference!",
              highlightFrame: CGRect.zero,
              arrowPosition: .top,
              popUpX: 0.5,
              popUpY: 0.045,
              arrowX: 0.5,
              arrowY: 0.45),
    
    GuideStep(id: "See Marker on Apple Watch",
              message: "You already set your dot marker, and now you can see the marker on your Apple Watch.",
              highlightFrame: CGRect.zero,
              arrowPosition: .bottom,
              popUpX: 0.5,
              popUpY: 0.51,
              arrowX: 0.5,
              arrowY: 0.9),
    
    GuideStep(id: "Want to get multi ratio ?",
              message: "Turn on multi ratio to get more photos",
              highlightFrame: CGRect.zero,
              arrowPosition: .bottom,
              popUpX: 0.5,
              popUpY: 0.63,
              arrowX: 0.83,
              arrowY: 0.2)
]

#Preview {
    ContentView()
}
