//
//  AppState.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 06/07/24.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
}
