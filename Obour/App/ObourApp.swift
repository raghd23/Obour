//
//  ObourApp.swift
//  Obour
//
//  Created by Raghad Alzemami on 15/08/1447 AH.
//
import SwiftUI

// @main tells Swift that this is the starting point of the app
@main
struct ObourApp: App {
    // AppState is created "ONCE" for the whole app
    // @StateObject ensures it lives for the entire app lifecycle
    // This is the single source of truth for navigation
    @StateObject private var appState = AppState()
    
    // A Scene represents a window or group of windows
    var body: some Scene {
        // WindowGroup is the main app window
        WindowGroup {
            // RootView decides which screen to show
            RootView()
                // Injects AppState into the SwiftUI environment
                // Any view can now access it using -->  @EnvironmentObject
                .environmentObject(appState)
        }
    }
}
