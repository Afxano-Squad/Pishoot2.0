//
//  HighlightFrameKey.swift
//  Pishoot
//
//  Created by Nadhirul Fatah Ulhaq on 05/07/24.
//

import SwiftUI

struct HighlightFrameKey: PreferenceKey {
    typealias Value = CGRect
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
