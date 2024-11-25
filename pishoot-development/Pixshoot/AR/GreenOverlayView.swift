//
//  GreenOverlay.swift
//  FinalChallengeDummy3
//
//  Created by Farid Andika on 21/10/24.
//

import SwiftUI

struct GreenOverlay: View {
    var overlayColor: Color

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(overlayColor)
                    .frame(width: 20, height: 5)
                Rectangle()
                    .fill(overlayColor)
                    .frame(width: 5, height: 20)
            }
            .position(x: 25, y: 25)

            VStack(alignment: .trailing, spacing: 0) {
                Rectangle()
                    .fill(overlayColor)
                    .frame(width: 20, height: 5)
                Rectangle()
                    .fill(overlayColor)
                    .frame(width: 5, height: 20)
            }
            .position(x: 155, y: 25)

            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(overlayColor)
                    .frame(width: 5, height: 20)
                Rectangle()
                    .fill(overlayColor)
                    .frame(width: 20, height: 5)
            }
            .position(x: 25, y: 95)

            VStack(alignment: .trailing, spacing: 0) {
                Rectangle()
                    .fill(overlayColor)
                    .frame(width: 5, height: 20)
                Rectangle()
                    .fill(overlayColor)
                    .frame(width: 20, height: 5)
            }
            .position(x: 155, y: 95)
        }
        .frame(width: 180, height: 120)
        .edgesIgnoringSafeArea(.all)
    }
}



struct GreenOverlay_Previews: PreviewProvider {
    static var previews: some View {
        GreenOverlay(overlayColor: .red)
    }
}
