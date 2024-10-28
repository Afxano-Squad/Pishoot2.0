//
//  PishootApp.swift
//  Pishoot
//
//  Created by Muhammad Zikrurridho Afwani on 25/06/24.
//

import SwiftUI

@main
struct PishootApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.hasCompletedOnboarding {
                ContentView()
            } else {
                OnBoardingContainerView().environmentObject(appState)
            }
        }
    }
}
