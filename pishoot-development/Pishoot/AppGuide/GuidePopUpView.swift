//
//  GuidePopUp.swift
//  Pishoot
//
//  Created by Nadhirul Fatah Ulhaq on 04/07/24.
//

import SwiftUI

struct GuidePopUpView: View {
    var step: GuideStep
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(step.id)
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(.black)
                .frame(width: 245, alignment: .topLeading)
            
            Text(step.message)
                .font(.subheadline)
                .foregroundColor(.black)
                .frame(width: 280, alignment: .topLeading)
        }
        .padding(.horizontal, 21)
        .padding(.top, 15)
        .padding(.bottom, 17)
        .frame(width: 320, alignment: .topLeading)
        .background(Color.yellow)
        .cornerRadius(10)
    }
}

#Preview {
    GuidePopUpView(step: GuideStep(id: "Top Control", message: "You can access more to set up by showing what’s in the top control.", highlightFrame: CGRect.zero, arrowPosition: .top, popUpX: UIScreen.main.bounds.width / 2, popUpY: UIScreen.main.bounds.height/4, arrowX: UIScreen.main.bounds.width / 2, arrowY: UIScreen.main.bounds.height / 3 - 30))
}
