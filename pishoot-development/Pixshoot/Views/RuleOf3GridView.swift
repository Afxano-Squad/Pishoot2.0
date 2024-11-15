//
//  RuleOf3GridView.swift
//  Pixshoot
//
//  Created by Farid Andika on 30/10/24.
//


import SwiftUI

struct RuleOf3GridView: View {
    
    var lineColor: Color = .red
    var lineWidth: CGFloat = 0.5
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let cornerLength: CGFloat = 20
                
                // Horizontal Lines (Rule of Thirds)
                path.move(to: CGPoint(x: 0, y: height / 3))
                path.addLine(to: CGPoint(x: width, y: height / 3))
                
                path.move(to: CGPoint(x: 0, y: 2 * height / 3))
                path.addLine(to: CGPoint(x: width, y: 2 * height / 3))
                
                // Vertical Lines (Rule of Thirds)
                path.move(to: CGPoint(x: width / 3, y: 0))
                path.addLine(to: CGPoint(x: width / 3, y: height))
                
                path.move(to: CGPoint(x: 2 * width / 3, y: 0))
                path.addLine(to: CGPoint(x: 2 * width / 3, y: height))
                
                // Top Left Corner
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: cornerLength, y: 0))
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 0, y: cornerLength))
                
                // Top Right Corner
                path.move(to: CGPoint(x: width - cornerLength, y: 0))
                path.addLine(to: CGPoint(x: width, y: 0))
                path.move(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: width, y: cornerLength))
                
                // Bottom Left Corner
                path.move(to: CGPoint(x: 0, y: height - cornerLength))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: cornerLength, y: height))
                
                // Bottom Right Corner
                path.move(to: CGPoint(x: width - cornerLength, y: height))
                path.addLine(to: CGPoint(x: width, y: height))
                path.move(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: width, y: height - cornerLength))
                
            }
            .stroke(lineColor, lineWidth: lineWidth)
        }
    }
}
