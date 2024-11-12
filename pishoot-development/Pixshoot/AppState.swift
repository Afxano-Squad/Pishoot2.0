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
        @Published var hasCompletedTutorial: Bool {
            didSet {
                UserDefaults.standard.set(hasCompletedTutorial, forKey: "hasCompletedTutorial")
            }
        }

        init() {
            self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
            self.hasCompletedTutorial = UserDefaults.standard.bool(forKey: "hasCompletedTutorial")
            print("Tutorial completion loaded from UserDefaults: \(self.hasCompletedTutorial)")
            
        }
}

