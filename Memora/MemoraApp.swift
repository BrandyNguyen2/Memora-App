//
//  MemoraApp.swift
//  Memora
//
//  Created by Alexis Nemsingh on 12/3/24.
//

import SwiftUI

@main
struct MemoraApp: App {
    // Initialize ThemeManager as a StateObject so it is preserved across views
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            // Pass the ThemeManager to the root view (LandingPageView)
            LandingPageView()
                .environmentObject(themeManager)
        }
    }
}

