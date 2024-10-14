//
//  UnsupportedDeviceView.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 14/07/24.
//

import SwiftUI

struct UnsupportedDeviceView: View {
    var body: some View {
        VStack {
            Text("Unsupported Device")
                .font(.title)
                .padding()
            Text("This app requires a device with an ultra-wide camera and 2x zoom capability.")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

#Preview {
    UnsupportedDeviceView()
}
