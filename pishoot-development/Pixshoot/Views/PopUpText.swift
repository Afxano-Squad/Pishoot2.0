//
//  PopUpText.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 04/11/24.
//

struct PopUpText : View {
   
    @State private var isFlashPopup = false
    @State private var isMultiFramePopup = false
    var body: some View {
        //pop up flash
        if isFlashPopup {
            VStack {
                Text(isFlashOn ? "Flash On" : "Flash Off")
                    .font(.callout)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                    .background(Color.black.opacity(0.7))
                    .clipShape(Capsule())
                    .transition(.scale)
            }
            .offset(y: -50)  // Position the popup above the button

        }

        // pop up multiframe
        if isMultiFramePopup {
            VStack {
                Text(
                    cameraViewModel.isMultiRatio
                        ? "Multiframe On" : "Multiframe Off"
                )
                .font(.callout)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 2)
                .background(Color.black.opacity(0.7))
                .clipShape(Capsule())
                .transition(.scale)
            }
            .offset(y: -50)  // Position the popup above the button
        }
    }
}
