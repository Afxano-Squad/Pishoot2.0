//
//  ArrowView.swift
//  Pishoot
//
//  Created by Nadhirul Fatah Ulhaq on 05/07/24.
//

import SwiftUI

struct ArrowView: View {
    var body: some View {
        Path { path in
            let width: CGFloat = 30
            let height: CGFloat = 30
            path.move(to: CGPoint(x: width / 2, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: width / 2, y: 0))
        }
        .fill(Color.yellow)
    }
}

#Preview {
    ArrowView()
}
