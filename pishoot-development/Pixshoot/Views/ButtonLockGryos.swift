//
//  ButtonLockGryos.swift
//  Pixshoot
//
//  Created by MUHAMMAD FAIQ ADHITYA FAQIH on 30/10/24.
//

import SwiftUI

struct ButtonLockGyros: View {
    @ObservedObject var gyroViewModel: GyroViewModel
    @Binding var isLocked: Bool

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.4)) {
                isLocked.toggle()
            }
            if isLocked {
                gyroViewModel.lockGyroCoordinates()
            } else {
                gyroViewModel.resetGyroValues()
            }
        }) {
            Image(systemName: isLocked ? "lock" : "lock.open")
                .resizable()
                .aspectRatio(contentMode: .fit) // Maintain aspect ratio to avoid stretching
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
//                .rotationEffect(.degrees(isLocked ? 0 : 180)) // Rotate icon when unlocked
                .scaleEffect(isLocked ? 1 : 1.2) // Enlarge slightly when unlocked
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isLocked)

    }
}
