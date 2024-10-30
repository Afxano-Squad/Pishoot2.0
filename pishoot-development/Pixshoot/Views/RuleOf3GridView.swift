//
//  RuleOf3GridView.swift
//  Pixshoot
//
//  Created by Farid Andika on 30/10/24.
//

import SwiftUI

struct RuleOf3GridView: View {
 
        
        var lineColor: Color = .white
        var lineWidth: CGFloat = 1
        
        var body: some View {
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
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
                    
                   
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: width, y: 0))
                    
                    // Bottom Border
                    path.move(to: CGPoint(x: 0, y: height))
                    path.addLine(to: CGPoint(x: width, y: height))
                    
                    // Left Border
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: height))
                    
                    // Right Border
                    path.move(to: CGPoint(x: width, y: 0))
                    path.addLine(to: CGPoint(x: width, y: height))
                }
                .stroke(lineColor, lineWidth: lineWidth)
            }
        }
    }
